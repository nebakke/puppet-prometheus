# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::scrape_job' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'testing basic config' do
      let(:params) do
        {
          'targets' => ['127.0.0.1:0000'],
          'labels' => {'foo' => 'bar'},
        }
      end
      let(:title) { 'foo_bar_job' }

      let :pre_condition do
        'include prometheus::server'
      end

      it { is_expected.to compile }

      it {
        is_expected.to contain_file('/etc/prometheus/file_sd_config.d').with_ensure('dir')
        is_expected.to contain_file("/etc/prometheus/file_sd_config.d/#{params['title']}.yaml").with(
          'ensure' => 'file',
          'owner' => 'root',
          'group' => 'prometheus',
          'mode' => '0640',
          'content' => <<-END
---
  - targets:  127.0.0.1:0000
  - labels:
    foo: bar
END
        )
      }
    end
  end
end
