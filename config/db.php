<?php
/**
 * Database Configuration
 *
 * All of your system's database connection settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/DbConfig.php.
 *
 * @see craft\config\DbConfig
 */

use craft\helpers\App;

$isDev = App::env('ENVIRONMENT') === 'dev';

if ($isDev) {
    $database_url = null;
} else {
    $database_url = parse_url(App::env('DATABASE_URL')) ?: null;
}

return [
    'dsn' => App::env('DB_DSN') ?: null,
    'driver' => App::env('DB_DRIVER'),
    'server' => App::env('DB_SERVER') ?: $database_url['host'],
    'port' => App::env('DB_PORT') ?: $database_url['port'],
    'database' => App::env('DB_DATABASE') ?: ltrim($database_url['path'], '/'),
    'user' => App::env('DB_USER') ?: $database_url['user'],
    'password' => App::env('DB_PASSWORD') ?: $database_url['pass'],
    'schema' => App::env('DB_SCHEMA'),
    'tablePrefix' => App::env('DB_TABLE_PREFIX'),
    'charset' => 'utf8',
    'collation' => 'utf8_unicode_ci',
];
