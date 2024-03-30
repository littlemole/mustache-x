<?php

namespace App;

use Psr\Log\LoggerInterface;
//use Symfony\Component\Finder\Finder;
//use Symfony\Component\HttpFoundation\Response;

use Illuminate\Filesystem\Filesystem;

use Mustache_Engine;

class Mustache
{
    private $engine;
    private $filesystem;

    public function __construct(Filesystem $filesystem) 
    {
        $this->engine = new Mustache_Engine(array('entity_flags' => ENT_QUOTES));
        $this->filesystem = $filesystem;
    }


    public function render(string $tpl, $ctx) : string
    {
        $templateDirectory = __DIR__.'/../resources/views/';

        $template = $this->filesystem->get($templateDirectory.$tpl);
        $content = $this->engine->render($template,$ctx);        
        return $content;
    }

}

?>
