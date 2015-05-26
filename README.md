# Tpck

`tpck` let you package your theme directory into a single file.

## Installation

```shell
gem install tpck
```

## Usage

### Packing

Where you have a directory called `examples/`:

```shell
tpck examples
```

This will create a new file called `examples.tpck`.

### Unpacking

```shell
tpck examples.tpck
```

This will recreate the original examples directory.

If you're receiving the package file inside a web app you can use the library directly without calling the binary. You can then say write the files to s3.

```
package = Tpck::Package.open(io)
packages.assets.each do |asset|
  write_to_bucket asset.path, asset.body
end
```

You can use `Tpck::Reader.new(io)` if the content is still gzipped. You can then pass it to `Tpck::Package`. Note that both `Tpck::Package.new(io)` and
`Tpck::Reader.new(io)` requires an IO like object.

## Dependencies

Tpck is entirely written using ruby stdlib so there should not be any dependencies.

## Contributing

1. Fork it ( https://github.com/robinclart/tpck/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
