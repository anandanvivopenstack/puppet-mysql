class mysql::configuration::performance {

  validate_re($::mysql::server::performance, ['^default','^small','^medium','^large','^huge'])

  case $::mysql::server::performance {
    'huge': {
      $config = {
        'key_buffer' =>                 { value  => '384M' },
        'max_allowed_packet' =>         { value  => '1M' },
        'table_cache' =>                { value  => '512' },
        'sort_buffer_size' =>           { value  => '2M' },
        'read_buffer_size' =>           { value  => '2M' },
        'read_rnd_buffer_size' =>       { value  => '8M' },
        'net_buffer_length' =>          { value  => '8K' },
        'myisam_sort_buffer_size' =>    { value  => '64M' },
        'thread_cache_size' =>          { value  => '8' },
        'query_cache_size' =>           { value  => '32M' },
        'thread_concurrency' =>         { value  => '8' },
        'thread_stack' =>               { ensure => absent },
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
        'key_buffer' =>                 { value  => '256M' },
        'max_allowed_packet' =>         { value  => '1M' },
        'table_cache' =>                { value  => '256' },
        'sort_buffer_size' =>           { value  => '1M' },
        'read_buffer_size' =>           { value  => '1M' },
        'read_rnd_buffer_size' =>       { value  => '4M' },
        'net_buffer_length' =>          { value  => '8K' },
        'myisam_sort_buffer_size' =>    { value  => '64M' },
        'thread_cache_size' =>          { value  => '8' },
        'query_cache_size' =>           { value  => '16M' },
        'thread_concurrency' =>         { value  => '8' },
        'thread_stack' =>               { ensure => absent },
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
        'key_buffer' =>                 { value  => '16M' },
        'max_allowed_packet' =>         { value  => '1M' },
        'table_cache' =>                { value  => '64' },
        'sort_buffer_size' =>           { value  => '512K' },
        'read_buffer_size' =>           { value  => '256K' },
        'read_rnd_buffer_size' =>       { value  => '512K' },
        'net_buffer_length' =>          { value  => '8K' },
        'myisam_sort_buffer_size' =>    { value  => '8M' },
        'thread_cache_size' =>          { ensure => absent },
        'query_cache_size' =>           { ensure => absent },
        'thread_concurrency' =>         { ensure => absent },
        'thread_stack' =>               { ensure => absent },
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
        'key_buffer' =>                 { value  => '16K' },
        'max_allowed_packet' =>         { value  => '1M' },
        'table_cache' =>                { value  => '4' },
        'sort_buffer_size' =>           { value  => '64K' },
        'read_buffer_size' =>           { value  => '256K' },
        'read_rnd_buffer_size' =>       { value  => '256K' },
        'net_buffer_length' =>          { value  => '2K' },
        'myisam_sort_buffer_size' =>    { ensure => absent },
        'thread_cache_size' =>          { ensure => absent },
        'query_cache_size' =>           { ensure => absent },
        'thread_concurrency' =>         { ensure => absent },
        'thread_stack' =>               { value  => '64K' },
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
