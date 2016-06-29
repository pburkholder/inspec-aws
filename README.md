# Inspec::Aws

This gem is a collection of custom [inspec](https://github.com/chef/inspec) resources targeting AWS resources.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'inspec-aws'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inspec-aws

## Usage

Take a look at the examples Inspec profile at `examples/profile`. You can run `examples/bin/demo_noncompliant_vpc.rb` which will launch a CloudFormation stack in us-west-2, run the inspec profile against it, and then delete the stack. The script assumes you have AWS cli credentials already setup.

A full run of the example with a local Bundle install will look like this, with Inspec 0.26.0:

```
env | grep -q AWS_SECRET && env | grep -q AWS_ACCESS || echo "Set AWS credentials"
bundle install --path vendor/bundle
bundle exec examples/bin/demo_noncompliant_vpc.rb
```

Results:
```
Launching CFN stack InspecAwsDemo-NonCompliant-20160629165421 in us-west-2
Waiting for stack to come up...
Stack created - vpc-id[vpc-a5b6c6c1]
Running Inspec on example profile...
  ✔  sg-1: Security Group sg-beee79d8 should not have ingress rule


Profile: Example profile (Example profile)
Version: 1.0.0
Target:  local://

     No tests executed.

Summary:   1 successful    1 failures    0 skipped
Deleting stack InspecAwsDemo-NonCompliant-20160629165421
```

The 'successful' test is on the default SecurityGroup, the failure is not, as of this writing, reported clearly. For more detail, uncomment the line with `print JSON.pretty_generate(runner.report)`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arothian/inspec-aws.
