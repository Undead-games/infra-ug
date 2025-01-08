<?php

declare(strict_types=1);

use App\Application\Actions\Dnas\ConnectAction;
use Slim\App;

return function (App $app) {
        $app->post("/{folder}/{action:connect|others}", ConnectAction::class);
};
