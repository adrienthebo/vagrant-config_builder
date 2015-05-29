# @see http://docs.vagrantup.com/v2/provisioning/puppet_apply.html
class ConfigBuilder::Model::Provisioner::Puppet < ConfigBuilder::Model::Base

  # @!attribute [rw] manifests_path
  #   @return [String] The path to the puppet manifests.
  attr_accessor :manifests_path

  # @!attribute [rw] manifest_file
  #   @return [String] The name of the manifest to apply
  attr_accessor :manifest_file

  # @!attribute [rw] module_path
  #   @return [String] A colon separated set of filesystem paths for Puppet
  attr_accessor :module_path

  # @!attribute [rw] facter
  #   @return [Hash] A hash of values to use as facts
  attr_accessor :facter

  # @!attribute [rw] options
  #   @return [String] An arbitrary set of arguments for the `puppet` command
  attr_accessor :options

  def to_proc
    Proc.new do |vm_config|
      vm_config.provision :puppet do |puppet_config|
        with_attr(:manifests_path) { |val| puppet_config.manifests_path = val }
        with_attr(:manifest_file)  { |val| puppet_config.manifest_file  = val }
        with_attr(:module_path)    { |val| puppet_config.module_path    = val }
        with_attr(:facter)         { |val| puppet_config.facter         = val }
        with_attr(:options)        { |val| puppet_config.options        = val }
      end
    end
  end

  ConfigBuilder::Model::Provisioner.register('puppet', self)
end
