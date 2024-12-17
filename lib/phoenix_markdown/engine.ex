defmodule PhoenixMarkdown.Engine do
  @moduledoc """
  a single public function (compile) that Phoenix uses to compile incoming templates. You should not need to call it yourself.
  """

  @behaviour Phoenix.Template.Engine

  @doc """
  Callback implementation for `Phoenix.Template.Engine.compile/2`

  Precompiles the String file_path into a function definition, using the EEx and Earmark engines

  The compile function is typically called for by Phoenix's html engine and isn't something
  you need to call your self.

  ### Parameters
    * `path` path to the template being compiled
    * `name` name of the template being compiled

  """
  def compile(path, name) do
    # get the earmark options from config and cast into the right struct
    earmark_options =
      case Application.get_env(:phoenix_markdown, :earmark) do
        %Earmark.Options{} = opts ->
          opts

        %{} = opts ->
          Kernel.struct!(Earmark.Options, opts)

        _ ->
          %Earmark.Options{}
      end

    path
    |> File.read!()
    |> Earmark.as_html!(earmark_options)
    |> handle_smart_tags(path, name)
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, file: path, line: 1)
  end

  defp handle_smart_tags(markdown, path, name) do
    restore =
      case Application.get_env(:phoenix_markdown, :server_tags) do
        :all -> true
        {:only, opt} -> only?(opt, path, name)
        [{:only, opt}] -> only?(opt, path, name)
        {:except, opt} -> except?(opt, path, name)
        [{:except, opt}] -> except?(opt, path, name)
        _ -> false
      end

    do_restore_smart_tags(markdown, restore)
  end

  defp do_restore_smart_tags(markdown, true) do
    smart_tag = ~r/&lt;%.*?%&gt;/
    markdown = Regex.replace(smart_tag, markdown, &HtmlEntities.decode/1)

    uri_smart_tag = ~r/%3C(%25)+.*?%25%3E/
    Regex.replace(uri_smart_tag, markdown, &URI.decode/1)
  end

  defp do_restore_smart_tags(markdown, _), do: markdown

  defp only?(name, _path, name) when is_bitstring(name), do: true

  defp only?(opt, path, _name) when is_bitstring(opt) do
    paths = Path.wildcard(opt)
    Enum.member?(paths, path)
  end

  defp only?(opts, path, name) when is_list(opts) do
    Enum.any?(opts, &only?(&1, path, name))
  end

  defp only?(regex, path, _) when is_struct(regex, Regex), do: String.match?(path, regex)

  defp only?(regex, _path, _) do
    raise ArgumentError,
          "Invalid parameter to PhoenixMarkdown only: configuration #{inspect(regex)}"
  end

  defp except?(name, _path, name) when is_bitstring(name), do: false

  defp except?(opt, path, _name) when is_bitstring(opt) do
    paths = Path.wildcard(opt)
    not Enum.member?(paths, path)
  end

  defp except?(opts, path, name) when is_list(opts) do
    Enum.all?(opts, &except?(&1, path, name))
  end

  defp except?(regex, path, _) when is_struct(regex, Regex), do: not String.match?(path, regex)

  defp except?(regex, _path, _) do
    raise ArgumentError,
          "Invalid parameter to PhoenixMarkdown except: configuration #{inspect(regex)}"
  end
end
