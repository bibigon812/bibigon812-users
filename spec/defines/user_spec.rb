# frozen_string_literal: true

require 'spec_helper'

describe 'users::user' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'without ssh_authorized_keys' do
        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_user('namevar') }
        it { is_expected.to contain_file('/home/namevar/.ssh') }
      end

      context 'with gid' do
        let(:params) do
          super().merge(gid: 'namevar')
        end

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_user('namevar') }
        it { is_expected.to contain_file('/home/namevar/.ssh').that_requires('User[namevar]') }
        it do
          is_expected.to contain_group('namevar-namevar')
            .that_comes_before('User[namevar]')
            .with_name('namevar')
        end
      end

      context 'with ssh_authorized_keys' do
        let(:params) do
          super().merge(
            ssh_authorized_keys: [
              {
                key: 'AAAAB3Nza[...]qXfdaQ==',
                type: 'ssh-rsa',
              },
            ],
          )
        end

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_user('namevar') }
        it { is_expected.to contain_file('/home/namevar/.ssh') }
        it do
          is_expected.to contain_ssh_authorized_key('namevar_0')
            .with_key('AAAAB3Nza[...]qXfdaQ==')
            .with_type('ssh-rsa')
        end
      end
    end
  end
end
