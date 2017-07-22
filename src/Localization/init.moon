-------------------------------------------------------------
-- Copyright Argochamber Interactive 2017
-------------------------------------------------------------

if not __global_directive_registry__
  export __global_directive_registry__ = {}

-- This class is a namespace library to parse the language files.
export class LanguageParser
  @EXPR_PAIR = '^(.-)%=(.*)'
  @EXPR_NAME = '^@namespace%s+(%w+)'
  @EXPR_ECHO = '^@echo%s+(.*)'
  @EXPR_NNAM = '^@namespace%.'
  @EXPR_CUST = '^@%{(%w+)%}%s*(.*)'

  @parse: (lines) ->
    table = {}
    namespace = nil
    for line in lines
      if line\sub(1,1) == '#' or (line\len!) == 0
        -- Is a comment
        _is_a_comment = true
      elseif line\match @EXPR_PAIR
        key, value = line\match @EXPR_PAIR
        if (key)
          if namespace
            key = "#{namespace}_#{key}"
          table[key] = value
        else
          error "Keypair key part parsing error! K:'#{key}', V:'#{value}' ->
  something is wrong in this match. Check your language file."
      elseif line\match @EXPR_NAME
        namespace = line\match @EXPR_NAME
      elseif line\match @EXPR_NNAM
        namespace = nil
      elseif line\match @EXPR_ECHO
        msg = line\match @EXPR_ECHO
        logger = system\getLogger LanguageParser
        logger\setVerbosityLevel Level.FINE.weight
        logger\log "echo '#{msg}'", Level.FINE
      elseif line\match @EXPR_CUST
        dir, args = line\match @EXPR_CUST
        if not __global_directive_registry__[dir]
          error "Not a known custom directive '#{dir}' found at the directive
registry! Please, ensure that your module is registering the directives properly
before all, else the language file will fail loading!"
      else
        error "Invalid token! Not known instruction '#{line}'
Make you sure that you're not defining a language pair
with a blank space at the beggining! (Also blank lines with blank spaces are
invalid grammar!)"
    return table

-- This class handles the language conversion for strings.
export class Language
  -- Loads a language file into a new instance of language manager.
  -- @param path
  -- @returns Language
  @fromFile: (path) ->
    Language LanguageParser.parse love.filesystem.lines path

  new: (data) =>
    @data = data

  -- Returns the equivalent string with localized names.
  -- @param string
  -- @returns strings
  localized: (string) =>
    string = string\gsub '([^@]?)@([A-Za-z_]*)', (s, repl) ->
      @data[repl] and s..@data[repl] or "#{s}@#{repl}"
    string = string\gsub '@@', '@'
    return string

  -- Returns the table with all it's strings localized.
  -- UIs should be localized prior to it's build, so when requiring an UI table
  -- localize it before passing it to the layout builder.
  -- @param table
  -- @returns table
  localizeTree: (table) =>
    if type(table) == 'table'
      t = {}
      for k, v in pairs table
        t[k] = @localizeTree v
      return t
    elseif type(table) == 'string'
      return @localized table
    else
      return table

  -- Requires a file that should only contain a table without functions and then
  -- calls the tree localize.
  -- The result is a localized table, this is used mainly in UIs.
  -- @param path
  -- @returns table
  localizeUI: (path) =>
    @localizeTree require(path)
