<?php

namespace App\Service;

use Symfony\Component\HttpFoundation\Response;

use Mustache_Engine;

class Mustache
{
    private $templates = array();
    private $engine;

    public function __construct() 
    {
        $this->engine = new Mustache_Engine(array('entity_flags' => ENT_QUOTES));
    }

    public function get(string $key) : string 
    {
        $templateDirectory = __DIR__.'/../../templates/';

        return file_get_contents($templateDirectory.$key);
    }

    public function render(string $tpl, $ctx) : string
    {
        $template = $this->get($tpl);
        $content = $this->engine->render($template,$ctx);        
        return $content;
    }

    public function response(string $tpl, $ctx) : Response
    {
        $content = $this->render($tpl,$ctx);
        return new Response($content);
    }

}

?>
