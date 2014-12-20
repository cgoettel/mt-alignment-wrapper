mt-alignment-wrapper
====================

##Dependencies
- Perl
- LaTeX
- LaTeX package Parallel: http://www.ctan.org/pkg/parallel

###Installation
Once all of the dependencies are met, the script can be run as is. Make sure the file has sufficient permissions to run, and run `perl wrapper.pl --help` for more information.

##Basic problem
There doesn't appear to be an easy way to parse TMX files and format them with LaTeX. Using the Parallel package, LaTeX can beautifully align bitext. This parser takes a TMX file as input (maximum two languages) and outputs a TeX file with the aligned text.

##Overall approach
This parser is a standalone program written in Perl with the following flags:

- `--input-file` (required): the name of the input file.
- `--output-file`: if specified, the output file will be named according to the option here; otherwise, the output file will be named the same as the input file (with `out-` prefixed to the filename).
- `--left-lang` (required): the two-letter code of the input language. The system will be tested for `en`. Extensible to other languages.
- `--right-lang` (required): the two-letter code of the output language. The system will be tested for `fr`. Extensible to other languages.
- `--help`: this will display a help prompt. If the required fields are not entered, the program will error and this is displayed.

The parser checks the command line arguments, ensuring that the correct options have been specified, and then runs through the TMX file. Unless the current line in the TMX is a `<tuv>` tag, the parser moves on. For every `<tuv>` tag, the parser grabs the language from that line and prints the contents of that tag on either the left or right (as user specified). Once both lines have been printed, `\ParallelPar` is printed which sets up the environment for the next line of text.

Currently, the TeX file is always generated with a header and footer (to make a complete TeX file), so the header is printed first, then the while loop, and finally the footer. See further in [Future work](#Future work).

##Technologies
- what technologies you will employ 

% (e.g. word spotting, language recognition, parsing, corpus development, text-to-speech, dialogue move engines, etc.)

Gary gave a presentation on MT and bitext alignment. This project will use one of the MT programs talked about (need his slides to figure out which one) and LaTeX for alignment. The main criteria for an MT program is that it can be used on the terminal. The output format isn't a huge concern because parsing text isn't too difficult.

##Tools
- what tools or toolkits you plan to use

% (e.g. Java, C++, PCKIMMO, etc.)

- Wrapper: Perl
- Makefile: Bash and make macros
- MT: still needs to be selected.
- Alignment: LaTeX

##Knowledge sources and corpora
The two included example files are General Conference talks that have been aligned using the LF Aligner tool.

##Evaluation
My original evaluation goal was:

> The system should be evaluated based on its ability to easily translate a file and produce a correctly formatted output file. Correctly formatted, in this case, means that the output file aligns the parallel texts accurately and according to the user's choice (sentence, paragraph, or none).

##Future work
- Complete Unicode to TeX conversion. So far only the letters that appear in the two sample files are converted. To help, there is a regex that will eliminate every character and TeX diacritical mark, making it easier to find which letters also need conversion.
- Use a Perl XML parser instead of doing everything manually.
- Support for more than two languages. Can Parallel handle more than two?
- Option to output a TeX file, just the relevant TeX body, or a complete PDF. To do this, simply add another command line option (e.g., `--output-format=` with options `body`, `tex`, `pdf`) that prints out just the contents of the while loop; the header, while loop, and footer; or runs `pdflatex` as well, respectively.
- (?) Integration with LF Aligner tool.
- Use a Module to read command line arguments.

##References
- http://ctan.org/pkg/parallel
- https://github.com/cgoettel/bible/
- https://github.com/cgoettel/mt-alignment-wrapper
