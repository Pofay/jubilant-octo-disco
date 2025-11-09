# Takeaways

## Prefer pattern matching over if-else. Use guards to capture the if condition.

I'm still a bit effiy on this but it takes advantage of the language features of first-class pattern-matching.

```elixir

# From this
defp to_codepoint_lowercase(encoded_value) do
    if rem(encoded_value, 27) == 0 do
        0
    else
        rem(encoded_value, 27)
    end
end

# To these
defp to_codepoint_lowercase(encoded_value) when rem(encoded_value, 27) == 0 do
    0
end

defp to_codepoint_lowercase(encoded_value) do
    rem(encoded_value, 27)
end
```

## Use built-in functions (like `reduce`) to loop rather than handmade recursion:

Most of the time in Elixir you'll be using an enumerable type (e.g `List`, `String`).

Instead of using recursion on these types, `reduce` is much cleaner.

```elixir
# Example 1
Enum.reduce(1..lines, hashtag_lines, fn i, acc ->
    new_line = create_hashtags(i)
    acc <> new_line <> "\n"
end)


# Example 2
Enum.reduce({[], "U"}, fn encoded_value, {decoded_message, decode_mode} ->
    decoded_value =
        case decode_mode do
          "U" ->
            decode_to_uppercase(encoded_value)

          "L" ->
            decode_to_lowercase(encoded_value)

          "P" ->
            decode_to_punctuation(encoded_value)
        end

    new_mode = get_decoding_mode(String.to_integer(encoded_value), decode_mode)

    {decoded_message ++ [decoded_value], new_mode}
end)
```

## To mimic console-like behavior in other languages use the `IO` module. 

Elixir doesn't have a main method/function so its best to do something like this:

```elixir
def run do
    case IO.gets("Enter a number: ") do
      "\n" ->
        IO.puts("No input (EOF).")
        :error

      line ->
        valid_checksum =
          line
          |> String.trim()
          |> validate()

        IO.puts("Is Checksum valid?: #{valid_checksum}")
        :ok
    end
end
```
