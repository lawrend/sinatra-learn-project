require './config/environment'

use Rack::MethodOverride
use UsersController
use EventsController
use ActivitiesController
run ApplicationController