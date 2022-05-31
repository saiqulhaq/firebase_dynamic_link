# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/sord/all/sord.rbi
#
# sord-3.0.1

module Sord
end
module Sord::Logging
  def self.add_hook(&blk); end
  def self.done(msg, item = nil); end
  def self.duck(msg, item = nil); end
  def self.enabled_types; end
  def self.enabled_types=(value); end
  def self.error(msg, item = nil); end
  def self.generic(kind, header, msg, item); end
  def self.hooks; end
  def self.infer(msg, item = nil); end
  def self.info(msg, item = nil); end
  def self.invoke_hooks(kind, msg, item); end
  def self.omit(msg, item = nil); end
  def self.silent=(value); end
  def self.silent?; end
  def self.valid_types?(value); end
  def self.warn(msg, item = nil); end
end
module Sord::Resolver
  def self.builtin_classes; end
  def self.clear; end
  def self.path_for(name); end
  def self.paths_for(name); end
  def self.prepare; end
  def self.resolvable?(name, item); end
end
module Sord::TypeConverter
  def self.handle_sord_error(name, log_warning, item, replace_errors_with_untyped); end
  def self.split_type_parameters(params); end
  def self.yard_to_parlour(yard, item = nil, replace_errors_with_untyped = nil, replace_unresolved_with_untyped = nil); end
end
class Sord::Generator
  def add_attributes(item); end
  def add_comments(item, typed_object); end
  def add_constants(item); end
  def add_methods(item); end
  def add_mixins(item); end
  def add_namespace(item); end
  def count_method; end
  def count_namespace; end
  def generate; end
  def initialize(options); end
  def object_count; end
  def populate; end
  def run; end
  def sort_params(pair1, pair2); end
  def warnings; end
end
class Sord::ParlourPlugin < Parlour::Plugin
  def generate(root); end
  def initialize(options); end
  def options; end
  def parlour; end
  def parlour=(arg0); end
  def self.with_clean_env(&block); end
end