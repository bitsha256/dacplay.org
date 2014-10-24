#!/usr/bin/env ruby
require 'erb'
require 'yaml'

LANG_PATH     = './lang'
TEMPLATE_PATH = './template'

default_lang  = 'en'

class Hash
  def deep_merge(other)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : (v2 || v1) }
    merge(other, &merger)
  end
end

class Wrapper
  attr_accessor :dict, :lang

  # @param lang_file [String]: language pack file
  # @param lang_default [String|nil]: if provided, default language pack will be loaded and provide default value for missing entry in lang_file
  def initialize(lang_file, lang_default = nil)
    @lang = lang_file.split('.').first
    @default_dict = {}
    @default_dict = YAML.load(File.read(lang_default, safe: true)) unless lang_default.nil?

    @dict = Hash.new('')
    @dict = @default_dict.deep_merge( YAML.load(File.read(lang_file, safe: true)) )
  end

  def get_binding
    binding
  end

  def render(opt = {})
    if opt[:partial]
      ERB.new( File.read("#{TEMPLATE_PATH}/_#{opt[:partial]}.html.erb") ).result
    end
  end

  # lookup language item for sig key, sig could be dot seperated string
  #
  # @param sig[String]: entry key
  #
  # @returns [String]: translation string
  def dd(sig)
    keys = sig.split('.').to_a
    cur = @dict
    while key = keys.shift
      cur = cur[key]
    end
    cur
  end

end

class Pager
  def self.write(file_path, content)
    File.open(file_path, 'w') do |f|
      f.write(content)
    end
  end
end

# loop available langs
Dir.glob("#{LANG_PATH}/*.yml") do |dict_file|
  lang    = File.basename(dict_file).split('.').first
  default_lang_file = lang != 'en' ? dict_file.sub(lang, 'en') : nil

  binding = Wrapper.new(dict_file, default_lang_file).get_binding

  # loop templates, exclude partial templates
  Dir.glob("#{TEMPLATE_PATH}/[^_]*.html.erb") do |template|
    page = ERB.new( File.read( template ) ).result( binding )
    output_file = "../#{File.basename(template).split('.').first}-#{lang}.html"

    Pager.write output_file, page
  end
end

# js compile and minify
# TODO: js minify
`coffee -bc -o ../js ./js/app.coffee; `

# css compile and minify
`sass -t compressed --scss --sourcemap=none ./css/app.scss ../css/app.css`