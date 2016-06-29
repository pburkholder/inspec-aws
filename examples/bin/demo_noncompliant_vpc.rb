#!/usr/bin/env ruby

require 'aws-sdk'
require 'inspec'
require 'inspec/aws'

ENV['AWS_REGION'] = 'us-west-2'

examples_home = File.dirname(__FILE__)+'/..'
template_body = File.read(File.join(examples_home,'noncompliant_vpc.json'))

cfn_client = Aws::CloudFormation::Client.new
cfn_resource = Aws::CloudFormation::Resource.new(client: cfn_client)

cfn_client.validate_template(template_body: template_body)

stack_name = "InspecAwsDemo-NonCompliant-#{Time.now.utc.strftime('%Y%m%d%H%M%S')}"

puts "Launching CFN stack #{stack_name} in #{ENV['AWS_REGION']}"
stack = cfn_resource.create_stack(
  stack_name: stack_name,
  template_body: template_body,
  timeout_in_minutes: 5,
  on_failure: 'DELETE'
)

puts 'Waiting for stack to come up...'
cfn_client.wait_until(:stack_create_complete, stack_name: stack_name) do |waiter|
  waiter.delay = 10
  waiter.max_attempts = 30
end
stack.load
vpc_id = stack.outputs.first.output_value
puts "Stack created - vpc-id[#{vpc_id}]"

#Set the VPC ID into the environment
ENV['vpc_id'] = vpc_id

#Run the profile through inspec
begin
  puts "Running Inspec on example profile..."
  o = {}
  o[:log_format] = 'json'
  o[:logger] = Logger.new(STDOUT)

  runner = Inspec::Runner.new(o)
  profile = Inspec::Profile.for_target(File.join(examples_home, './profile'),{})
  runner.add_profile(profile)
  runner.run
  # print JSON.pretty_generate(runner.report)

ensure
  puts "Deleting stack #{stack_name}"
  stack.delete
end
