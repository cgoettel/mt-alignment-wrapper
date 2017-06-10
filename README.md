tmx-latex-parser
====================

## Dependencies
- Perl
- LaTeX
- LaTeX package Parallel: http://www.ctan.org/pkg/parallel

### Installation
Once all of the dependencies are met, the script can be run as is. Make sure the file has sufficient permissions to run, and run `perl wrapper.pl --help` for more information.

## Basic problem
There doesn't appear to be an easy way to parse TMX files and format them with LaTeX. Using the Parallel package, LaTeX can beautifully align bitext. This parser takes a TMX file as input (maximum two languages) and outputs a TeX file with the aligned text.

## Overall approach
This parser is a standalone program written in Perl with the following flags:

- `--input-file` (required): the name of the input file.
- `--output-file`: if specified, the output file will be named according to the option here; otherwise, the output file will be named the same as the input file (with `out-` prefixed to the filename).
- `--left-lang` (required): the two-letter code of the input language. The system will be tested for `en`. Extensible to other languages.
- `--right-lang` (required): the two-letter code of the output language. The system will be tested for `fr`. Extensible to other languages.
- `--help`: this will display a help prompt. If the required fields are not entered, the program will error and this is displayed.

The parser checks the command line arguments, ensuring that the correct options have been specified, and then runs through the TMX file. Unless the current line in the TMX is a `<tuv>` tag, the parser moves on. For every `<tuv>` tag, the parser grabs the language from that line and prints the contents of that tag on either the left or right (as user specified). Once both lines have been printed, `\ParallelPar` is printed which sets up the environment for the next line of text.

For every line, the parser converts any Unicode characters into TeX-friendly diacritical marks. For example, `é` is converted to `\'e`. This function, `unicode_to_tex` does not parse for every Unicode character, simply the ones that appear in the two sample files. See Future work below.

Currently, the TeX file is always generated with a header and footer (to make a complete TeX file), so the header is printed first, then the while loop, and finally the footer. Lastly, `pdflatex` is run, generating a PDF file. See Future work below.

## Knowledge sources and corpora
The two included example files are General Conference talks that have been aligned using the LF Aligner tool.

## Evaluation
My original evaluation goal was:

> The system should be evaluated based on its ability to easily produce a correctly formatted output file. Correctly formatted, in this case, means that the output file aligns the parallel texts accurately and according to the given TMX file.

This parser fulfills those requirements, although there is plenty of improvement that can be made.

## Future work
- Complete Unicode to TeX conversion. So far only the letters that appear in the two sample files are converted. To help, there is a function called `check_unicode_to_tex` that will eliminate every character and TeX diacritical mark, making it easier to find which letters still need to be converted.
- Use a Perl XML parser instead of doing everything manually.
- Support for more than two languages. Can Parallel handle more than two?
- Option to output a TeX file, just the relevant TeX body, or a complete PDF. To do this, simply add another command line option (e.g., `--output-format=` with options `body`, `tex`, `pdf`) that prints out just the contents of the while loop; the header, while loop, and footer; or runs `pdflatex` as well, respectively.
- (?) Integration with LF Aligner tool.
- Use a Module to read command line arguments.

## References
- http://ctan.org/pkg/parallel
