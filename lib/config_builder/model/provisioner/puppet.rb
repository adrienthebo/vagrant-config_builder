# @see http://docs.vagrantup.com/v2/provisioning/puppet_apply.html
class ConfigBuilder::Model::Provisioner::Puppet < ConfigBuilder::Model::Base

  # @!attribute [rw] binary_path
  #   @return [String] The path to Puppet's `bin` directory.
  attr_accessor :binary_path

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

  # @!attribute [rw] hiera_config_path
  #   @return [String] Path to the Hiera configuration file stored on the host
  #   @since 0.15.0
  attr_accessor :hiera_config_path

  # @!attribute [rw] working_directory
  #   @return [String] Path in the guest that will be the working directory when Puppet is executed
  #   @since 0.15.0
  attr_accessor :working_directory

  # @!attribute [rw] environment
  #   @return [String] Name of the Puppet environment.
  attr_accessor :environment

  # @!attribute [rw] environment_path
  #   @return [String] Path to the directory that contains environment files on the host disk.
  attr_accessor :environment_path

  # @!attribute [rw] synced_folder_type
  #   @return [String] The type of synced folders to use when sharing the data required for the provisioner to work properly.
  attr_accessor :synced_folder_type

  # @!attribute [rw] synced_folder_args
  #   @return [Array<String>] Arguments that are passed to the folder sync.
  attr_accessor :synced_folder_args

  # @!attribute [rw] temp_dir
  #   @return [String] The directory where the data associated with the Puppet run will be stored on the guest machine.
  attr_accessor :temp_dir

  def to_proc
    Proc.new do |vm_config|
      vm_config.provision :puppet do |puppet_config|
        with_attr(:binary_path)        { |val| puppet_config.binary_path        = val }
        with_attr(:manifests_path)     { |val| puppet_config.manifests_path     = val }
        with_attr(:manifest_file)      { |val| puppet_config.manifest_file      = val }
        with_attr(:module_path)        { |val| puppet_config.module_path        = val }
        with_attr(:facter)             { |val| puppet_config.facter             = val }
        with_attr(:options)            { |val| puppet_config.options            = val }
        with_attr(:hiera_config_path)  { |val| puppet_config.hiera_config_path  = val }
        with_attr(:working_directory)  { |val| puppet_config.working_directory  = val }
        with_attr(:environment)        { |val| puppet_config.environment        = val }
        with_attr(:environment_path)   { |val| puppet_config.environment_path   = val }
        with_attr(:synced_folder_type) { |val| puppet_config.synced_folder_type = val }
        with_attr(:synced_folder_args) { |val| puppet_config.synced_folder_args = val }
        with_attr(:temp_dir)           { |val| puppet_config.temp_dir           = val }
      end
    end
  end

  ConfigBuilder::Model::Provisioner.register('puppet', self)
end
