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
        puppet_config.manifests_path = attr(:manifests_path) if attr(:manifests_path)
        puppet_config.manifest_file  = attr(:manifest_file)  if attr(:manifest_file)
        puppet_config.module_path    = attr(:module_path)    if attr(:module_path)
        puppet_config.facter         = attr(:facter)         if attr(:facter)
        puppet_config.options        = attr(:options)        if attr(:options)
      end
    end
  end

  ConfigBuilder::Model::Provisioner.register('puppet', self)
end
