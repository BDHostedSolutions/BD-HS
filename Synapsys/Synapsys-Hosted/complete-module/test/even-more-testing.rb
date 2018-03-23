# spec/infrastructure/core/kubernetes_cluster_spec.rb
require 'spec_helper'
require 'set'
 
describe "KubernetesCluster" do
  before(:all) do
    @vpc_details = $terraform_plan['aws_vpc.infrastructure']
    @controllers_found =
      $terraform_plan['kubernetes-cluster'].select do |key,value|
        key.match /aws_instance\.kubernetes_controller/
      end
    @coreos_amis = obtain_latest_coreos_version_and_ami!
  end
 
  context "Controller" do
    context "Metadata" do
      it "should have retrieved EC2 details" do
        expect(@controllers_found).not_to be_nil
      end
    end
 
    context "Sizing" do
      it "should be defined" do
        expect($terraform_tfvars['kubernetes_controller_count']).not_to be_nil
      end
      
      
      it "should be replicated the correct number of times" do
        expected_number_of_kube_controllers = \
          $terraform_tfvars['kubernetes_controller_count'].to_i
        expect(@controllers_found.count).to eq expected_number_of_kube_controllers
      end
 
      it "should use the same AZ across all Kubernetes controllers" do
        # We aren't testing that these controllers actually have AZs
        # (it can be empty if not defined). We're solely testing that 
        # they are the same within this AZ.
        azs_for_each_controller = @controllers_found.values.map do |controller_config|
          controller_config['availability_zone']
        end
        deduplicated_az_set = Set.new(azs_for_each_controller)
        expect(deduplicated_az_set.count).to eq 1
      end
    end
 
    it "should be fetching the latest stable release of CoreOS for region \
      #{ENV['AWS_REGION']}" do
      @controllers_found.keys.each do |kube_controller_resource_name|
        this_controller_details =
          @controllers_found[kube_controller_resource_name]
        expected_ami_id = @coreos_amis[ENV['AWS_REGION']]['hvm']
        actual_ami_id = this_controller_details['ami']
        expect(expected_ami_id).to eq expected_ami_id
      end
    end
 
    it "should use the instance size requested" do
      @controllers_found.keys.each do |kube_controller_resource_name|
        this_controller_details =
          @controllers_found[kube_controller_resource_name]
        actual_instance_size = this_controller_details['instance_type']
        expected_instance_size =
          $terraform_tfvars['kubernetes_controller_instance_size']
        expect(expected_instance_size).to eq actual_instance_size
      end
    end
 
    it "should use the key provided" do
      @controllers_found.keys.each do |kube_controller_resource_name|
        this_controller_details =
          @controllers_found[kube_controller_resource_name]
        actual_ec2_instance_key_name = this_controller_details['key_name']
        expected_ec2_instance_key_name =
          $terraform_tfvars['kubernetes_controller_ec2_instance_key_name']
        expect(expected_ec2_instance_key_name).to eq actual_ec2_instance_key_name
      end
    end
  end
end
