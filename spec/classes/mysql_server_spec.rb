require 'spec_helper'

describe 'mysql::server' do

  # TODO: try to remove mysql_* variables
  let(:facts) {{
    :mysql_backupdir     => :undef,
    :mysql_data_dir      => :undef,
    :mysql_logfile_group => :undef,
    :mysql_password      => :undef,
    :mysql_user          => :undef,
    :operatingsystem     => 'Debian',
    :osfamily            => 'Debian',
  }}

  it { pending('rspec-puppet bug ?') { should compile.with_all_deps } }

end
