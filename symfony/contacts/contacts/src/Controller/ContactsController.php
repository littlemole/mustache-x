<?php
namespace App\Controller;

use App\Entity\Contact;
use App\Service\Mustache;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class ContactsController extends AbstractController
{
    #[Route('/contacts', name: 'contacts')]
    public function contacts(
        Request $request,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        Mustache $mustache): Response
    {
        $search = $request->query->get('q');
        $contacts;
        $count = $entityManager->getRepository(Contact::class)->contacts_count();
        
        $logger->info("CONTACT COUNT: " .$count);

        if($search)
        {
            $contacts = $entityManager->getRepository(Contact::class)->search($search);
        }
        else
        {
            $contacts = $entityManager->getRepository(Contact::class)->findAll();
        }

        if (!$contacts) {
            $contacts = array();
        }

        $viewdata = array(
            "contacts" => $contacts,
            "count" => $count
        );

        return $mustache->response("index.tpl",$viewdata);
    }

    #[Route('/contacts/count', methods: ['GET'])]
    public function count(
        Request $request,
        EntityManagerInterface $entityManager) 
        : Response
    {
        $count = $entityManager->getRepository(Contact::class)->count();

        return new Response($count);
    }

    #[Route('/contacts/new', methods: ['GET'])]
    public function create(
        Request $request,
        EntityManagerInterface $entityManager,
        Mustache $mustache ) 
        : Response
    {
        $viewdata = array(                
            "errors" => array(),
            "contact" => null
        );

        return $mustache->response("new.tpl",$viewdata);
    }

    #[Route('/contacts/new', methods: ['POST'])]
    public function insert(
        Request $request,
        EntityManagerInterface $entityManager,
        Mustache $mustache ) 
        : Response
    {
        $email = $request->get("email");
        $first = $request->get("first_name");
        $last = $request->get("last_name");
        $phone = $request->get("phone");

        $contact = new Contact();
        $contact->setEmail($email);
        $contact->setFirst($first);
        $contact->setLast($last);
        $contact->setPhone($phone);

        $errors = array();
        if(!$email)
        {
            $errors["email"] = "Email is required.";
        }
        if(!$first)
        {
            $errors["first"] = "First name is required.";
        }

        $existing = $entityManager->getRepository(Contact::class)->find_by_email($email);
        if($existing)
        {
            $errors["email"] = "Email must be unique.";
        }

        if(count($errors))
        {
            $viewdata = array(                
                "errors" => $errors,
                "contact" => $contact
            );
    
            return $mustache->response("new.tpl",$viewdata);
        }


        $entityManager->persist($contact);
        $entityManager->flush();

        return $this->redirect('/contacts');
    }        

    #[Route('/contacts/{id}', methods: ['GET'])]
    public function show(
        int $id,
        EntityManagerInterface $entityManager,
        Mustache $mustache ) 
        : Response
    {
        $contact = $entityManager->getRepository(Contact::class)->find($id);

        return $mustache->response("show.tpl",$contact);
    }

    #[Route('/contacts/{id}/email', methods: ['GET'])]
    public function email(
        int $id,
        Request $request,
        EntityManagerInterface $entityManager) 
        : Response
    {        
        $email = $request->get("email");

        $contact = $entityManager->getRepository(Contact::class)->find_by_email($email);
        if(!$contact)
        {
            return new Response("");
        }
        if($contact->getId() == $id)
        {
            return new Response("");
        }

        return new Response("Email already taken.");
    }



    #[Route('/contacts/{id}/edit', methods: ['GET'])]
    public function edit(
        int $id,
        EntityManagerInterface $entityManager,
        Mustache $mustache ) 
        : Response
    {
        $contact = $entityManager->getRepository(Contact::class)->find($id);

        $viewdata = array(                
            "errors" => array(),
            "contact" => $contact
        );

        return $mustache->response("edit.tpl",$viewdata);
    }    

    #[Route('/contacts/{id}/edit', methods: ['POST'])]
    public function update(
        int $id,
        Request $request,
        EntityManagerInterface $entityManager,
        Mustache $mustache ) 
        : Response
    {
        $contact = $entityManager->getRepository(Contact::class)->find($id);

        $email = $request->get("email");
        $first = $request->get("first_name");
        $last = $request->get("last_name");
        $phone = $request->get("phone");

        $errors = array();
        if(!$email)
        {
            $errors["email"] = "Email is required.";
        }
        if(!$first)
        {
            $errors["first"] = "First name is required.";
        }

        $existing = $entityManager->getRepository(Contact::class)->find_by_email($email);
        if($existing && $existing->getId() != $id)
        {
            $errors["email"] = "Email must be unique.";
        }

        if($contact)
        {
            $contact->setEmail($email);
            $contact->setFirst($first);
            $contact->setLast($last);
            $contact->setPhone($phone);
        }

        if(count($errors))
        {
            $viewdata = array(                
                "errors" => $errors,
                "contact" => $contact
            );
    
            return $mustache->response("edit.tpl",$viewdata);
        }

        if($contact)
        {
            $entityManager->persist($contact);
            $entityManager->flush();
        }

        return $this->redirect('/contacts');
    }    

    #[Route('/contacts/{id}', methods: ['DELETE'])]
    public function remove(
        int $id,
        Request $request,
        EntityManagerInterface $entityManager) 
        : Response
    {
        $contact = $entityManager->getRepository(Contact::class)->find($id);

        if($contact)
        {
            $entityManager->remove($contact);
            $entityManager->flush();
        }

        if( $request->headers->get('HX-Trigger') == 'delete-btn')
            return $this->redirectToRoute('contacts');
    
        $r = new Response('');
        $r->headers->set("HX-Trigger","recountEvent");
        return $r;
    }    

}
