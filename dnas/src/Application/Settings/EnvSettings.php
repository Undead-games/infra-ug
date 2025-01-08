<?php

declare(strict_types=1);

namespace App\Application\Settings;

use Exception;
use Monolog\Logger;


class EnvSettings implements SettingsInterface
{
    private array $settings;

    public function __construct()
    {
        $production = true;

        $this->settings = [
            "production"          => $production,
            "displayErrorDetails" => ! $production,
            "logError"            => filter_var($_ENV["LOG_ERROR"] ?? false, FILTER_VALIDATE_BOOL),
            "logErrorDetails"     => filter_var($_ENV["LOG_ERROR_DETAILS"] ?? false, FILTER_VALIDATE_BOOL),
            "logger" => [
                "name"  => "dnas-ug",
                "path"  => "php://stdout",
                "level" => $_ENV["LOG_LEVEL"] ?? Logger::INFO
            ],
        ];
    }

    /**
     * @return mixed
     */
    public function get(string $key = '')
    {
        if (! isset($this->settings[$key])) {
            throw new Exception("Unknown setting $key.");
        }

        return $this->settings[$key];
    }
}
