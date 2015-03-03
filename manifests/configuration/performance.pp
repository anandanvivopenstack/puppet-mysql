class mysql::configuration::performance {

  validate_re($::mysql::server::performance, ['^default','^small','^medium','^large','^huge'])

  case $::mysql::server::performance {
    'huge': {
      $config = {
        'mysqld/key_buffer' =>                 { value  => '384M' },
        'mysqld/max_allowed_packet' =>         { value  => '1M' },
        'mysqld/table_cache' =>                { value  => '512' },
        'mysqld/sort_buffer_size' =>           { value  => '2M' },
        'mysqld/read_buffer_size' =>           { value  => '2M' },
        'mysqld/read_rnd_buffer_size' =>       { value  => '8M' },
        'mysqld/net_buffer_length' =>          { value  => '8K' },
        'mysqld/myisam_sort_buffer_size' =>    { value  => '64M' },
        'mysqld/thread_cache_size' =>          { value  => '8' },
        'mysqld/query_cache_size' =>           { value  => '32M' },
        'mysqld/thread_concurrency' =>         { value  => '8' },
        'mysqld/thread_stack' =>               { ensure => absent },
        'isamchk/key_buffer' =>         { value  => '256M' },
        'isamchk/sort_buffer_size' =>   { value  => '256M' },
        'isamchk/read_buffer' =>        { value  => '2M' },
        'isamchk/write_buffer' =>       { value  => '2M' },
        'myisamchk/key_buffer' =>       { value  => '256M' },
        'myisamchk/sort_buffer_size' => { value  => '256M' },
        'myisamchk/read_buffer' =>      { value  => '2M' },
        'myisamchk/write_buffer' =>     { value  => '2M' },
      }
    }
    'large': {
      $config = {
        'mysqld/key_buffer' =>                 { value  => '256M' },
        'mysqld/max_allowed_packet' =>         { value  => '1M' },
        'mysqld/table_cache' =>                { value  => '256' },
        'mysqld/sort_buffer_size' =>           { value  => '1M' },
        'mysqld/read_buffer_size' =>           { value  => '1M' },
        'mysqld/read_rnd_buffer_size' =>       { value  => '4M' },
        'mysqld/net_buffer_length' =>          { value  => '8K' },
        'mysqld/myisam_sort_buffer_size' =>    { value  => '64M' },
        'mysqld/thread_cache_size' =>          { value  => '8' },
        'mysqld/query_cache_size' =>           { value  => '16M' },
        'mysqld/thread_concurrency' =>         { value  => '8' },
        'mysqld/thread_stack' =>               { ensure => absent },
        'isamchk/key_buffer' =>         { value  => '128M' },
        'isamchk/sort_buffer_size' =>   { value  => '128M' },
        'isamchk/read_buffer' =>        { value  => '2M' },
        'isamchk/write_buffer' =>       { value  => '2M' },
        'myisamchk/key_buffer' =>       { value  => '128M' },
        'myisamchk/sort_buffer_size' => { value  => '128M' },
        'myisamchk/read_buffer' =>      { value  => '2M' },
        'myisamchk/write_buffer' =>     { value  => '2M' },
      }
    }
    'medium': {
      $config = {
        'mysqld/key_buffer' =>                 { value  => '16M' },
        'mysqld/max_allowed_packet' =>         { value  => '1M' },
        'mysqld/table_cache' =>                { value  => '64' },
        'mysqld/sort_buffer_size' =>           { value  => '512K' },
        'mysqld/read_buffer_size' =>           { value  => '256K' },
        'mysqld/read_rnd_buffer_size' =>       { value  => '512K' },
        'mysqld/net_buffer_length' =>          { value  => '8K' },
        'mysqld/myisam_sort_buffer_size' =>    { value  => '8M' },
        'mysqld/thread_cache_size' =>          { ensure => absent },
        'mysqld/query_cache_size' =>           { ensure => absent },
        'mysqld/thread_concurrency' =>         { ensure => absent },
        'mysqld/thread_stack' =>               { ensure => absent },
        'isamchk/key_buffer' =>         { value  => '20M' },
        'isamchk/sort_buffer_size' =>   { value  => '20M' },
        'isamchk/read_buffer' =>        { value  => '2M' },
        'isamchk/write_buffer' =>       { value  => '2M' },
        'myisamchk/key_buffer' =>       { value  => '20M' },
        'myisamchk/sort_buffer_size' => { value  => '20M' },
        'myisamchk/read_buffer' =>      { value  => '2M' },
        'myisamchk/write_buffer' =>     { value  => '2M' },
      }
    }
    'small': {
      $config = {
        'mysqld/key_buffer' =>                 { value  => '16K' },
        'mysqld/max_allowed_packet' =>         { value  => '1M' },
        'mysqld/table_cache' =>                { value  => '4' },
        'mysqld/sort_buffer_size' =>           { value  => '64K' },
        'mysqld/read_buffer_size' =>           { value  => '256K' },
        'mysqld/read_rnd_buffer_size' =>       { value  => '256K' },
        'mysqld/net_buffer_length' =>          { value  => '2K' },
        'mysqld/myisam_sort_buffer_size' =>    { ensure => absent },
        'mysqld/thread_cache_size' =>          { ensure => absent },
        'mysqld/query_cache_size' =>           { ensure => absent },
        'mysqld/thread_concurrency' =>         { ensure => absent },
        'mysqld/thread_stack' =>               { value  => '64K' },
        'isamchk/key_buffer' =>         { value  => '8M' },
        'isamchk/sort_buffer_size' =>   { value  => '8M' },
        'isamchk/read_buffer' =>        { ensure => absent },
        'isamchk/write_buffer' =>       { ensure => absent },
        'myisamchk/key_buffer' =>       { value  => '8M' },
        'myisamchk/sort_buffer_size' => { value  => '8M' },
        'myisamchk/read_buffer' =>      { ensure => absent },
        'myisamchk/write_buffer' =>     { ensure => absent },
      }
    }
    'default': {
      $config = {}
    }
    default: { fail 'Undefined performance level' }
  }
    
}
