<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ContactsController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/contacts/count', [ContactsController::class, "count"]);

Route::get('/contacts/new', [ContactsController::class, "create"]);

Route::post('/contacts/new', [ContactsController::class, "insert"]);

Route::get('/contacts/{id}', [ContactsController::class, "show"]);

Route::get('/contacts/{id}/email', [ContactsController::class, "email"]);

Route::get('/contacts/{id}/edit', [ContactsController::class, "edit"]);

Route::post('/contacts/{id}/edit', [ContactsController::class, "update"]);

Route::delete('/contacts/{id}', [ContactsController::class, "remove"]);

Route::get('/contacts', [ContactsController::class, "contacts"]);

