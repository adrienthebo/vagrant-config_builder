# @see http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html
class ConfigBuilder::Model::VM < ConfigBuilder::Model::Base

  include ConfigBuilder::ModelDelegator

  # @!attribute [rw] provider
  #   @return [Hash<Symbol, Object>] The provider configuration for
  #     this VM
  #   @example
  #     >> vm.provider
  #     => {
  #           :type => 'virtualbox',
  #           :name => 'tiny-tina',
  #           :gui  => false,
  #        }
  def_model_delegator :provider

  # @!attribute [rw] providers
  #   @return [Array<Hash{String, Symbol => Object}>] A collection of provider
  #     parameters that should be applied to a VM.
  #   @example
  #     >> vm.providers
  #     => [
  #          {:type => 'virtualbox', :customize => ['modifyvm', :id, '--memory', 1024]},
  #          {:type => 'vmware_fusion', :vmx => {:memsize => 1024}},
  #        ]
  def_model_delegator :providers

  # @!attribute [rw] provisioners
  #   @return [Array<Hash<Symbol, Object>>] A collection of provisioner
  #     parameters in the order that they should be applied
  #     of provisioner types, and a list of provisioner instances for each type
  #   @example
  #     >> vm.provisioners
  #     => [
  #           {:type => :shell, :path   => '/vagrant/bin/magic.sh'},
  #           {:type => :shell, :inline => '/bin/echo hello world'},
  #
  #           {:type => :puppet, :manifest => 'foo.pp'},
  #           {:type => :puppet, :manifest => 'bar.pp', :modulepath => '/vagrant/modules'},
  #        ]
  def_model_delegator :provisioners

  # @!attribute [rw] forwarded_ports
  #   @return [Array<Hash<Symbol, Object>>] A collection of port mappings
  #   @example
  #     >> vm.forwarded_ports
  #     => [
  #           {:guest => 80, :host  => 20080},
  #           {:guest => 443, :host => 20443},
  #        ]
  def_model_delegator :forwarded_ports

  # @!attribute [rw] private_networks
  #   @return [Array<Hash<Symbol, Object>>] A collection of IP address network
  #     settings.
  #   @example
  #     >> vm.private_networks
  #     => [
  #           {:ip => '10.20.4.1'},
  #           {:ip => '192.168.100.5', :netmask => '255.255.255.128'},
  #        ]
  def_model_delegator :private_networks

  # @!attribute [rw] synced_folders
  #   @return [Array<Hash<Symbol, Object>>]
  #   @example
  #     >> vm.synced_folders
  #     => [
  #           {:host_path => 'manifests/', :guest_path => '/root/manifests', :disabled => false},
  #           {:host_path => 'modules/', :guest_path => '/root/modules'},
  #        ]
  #
  def_model_delegator :synced_folders

  # @!attribute [rw] plugins
  #   @return [Array<Hash<Symbol, Object>>]
  #   @example
  #     >> config.plugins
  #     => [
  #           {:plugin => 'vagrant-vbguest', :config_attribute => 'vbguest', {:auto_update => false, }},
  #        ]
  def_model_delegator :plugins

  # @!attribute [rw] box
  #   @return [String] The name of the Vagrant box to instantiate for this VM
  def_model_attribute :box

  # @!attribute [rw] guest
  #   @return [String] The guest type to use for this VM
  def_model_attribute :guest

  # @!attribute [rw] box_url
  #   @return [String] The source URL for the Vagrant box associated with this VM
  def_model_attribute :box

  # @!attribute [rw] name
  #   @return [String] The name of the instantiated box in this environment
  def_model_attribute :name

  # @!attribute [rw] hostname
  #   @return [String] The hostname the machine should have.
  def_model_attribute :hostname

  # @!attribute [rw] communicator
  #   @return [String] The name of the communicator to use when sending
  #   commands to this box. Set to 'winrm' for Windows VMs.
  def_model_attribute :communicator

  def initialize
    @defaults = {
      :providers        => [],
      :provisioners     => [],
      :forwarded_ports  => [],
      :private_networks => [],
      :synced_folders   => [],
      :plugins          => [],
    }
  end

  def to_proc
    Proc.new do |global_config|
      global_config.vm.define(attr(:name)) do |config|
        vm_config = config.vm

        with_attr(:box)      { |val| vm_config.box      = attr(:box)      }
        with_attr(:box_url)  { |val| vm_config.box_url  = attr(:box_url)  }
        with_attr(:hostname) { |val| vm_config.hostname = attr(:hostname) }
        with_attr(:guest)    { |val| vm_config.guest    = attr(:guest)    }

        with_attr(:communicator) { |val| vm_config.communicator = attr(:communicator) }

        eval_models(vm_config)
      end
      eval_plugins(global_config)
    end
  end

  private

  def eval_provisioners(vm_config)
    attr(:provisioners).each do |hash|
      p = ConfigBuilder::Model::Provisioner.new_from_hash(hash)
      p.call(vm_config)
    end
  end

  def eval_providers(vm_config)
    attr(:providers).each do |hash|
      p = ConfigBuilder::Model::Provider.new_from_hash(hash)
      p.call(vm_config)
    end
  end

  def eval_provider(vm_config)
    if attr(:provider)
      p = ConfigBuilder::Model::Provider.new_from_hash(attr(:provider))
      p.call(vm_config)
    end
  end

  def eval_private_networks(vm_config)
    attr(:private_networks).each do |hash|
      n = ConfigBuilder::Model::Network::PrivateNetwork.new_from_hash(hash)
      n.call(vm_config)
    end
  end

  def eval_forwarded_ports(vm_config)
    attr(:forwarded_ports).each do |hash|
      f = ConfigBuilder::Model::Network::ForwardedPort.new_from_hash(hash)
      f.call(vm_config)
    end
  end

  def eval_synced_folders(vm_config)
    attr(:synced_folders).each do |hash|
      f = ConfigBuilder::Model::SyncedFolder.new_from_hash(hash)
      f.call(vm_config)
    end
  end

  def eval_plugins(global_config)
    attr(:plugins).each do |hash|
      f = ConfigBuilder::Model::PluginEntry.new_from_hash(hash)
      f.call(global_config)
    end
  end
end
