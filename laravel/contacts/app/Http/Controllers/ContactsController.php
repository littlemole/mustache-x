<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\View\View;
//use Illuminate\Routing\Redirector;
use App\Http\Controllers\Controller;
use App\Models\Contact;
use App\Mustache;

use Psr\Log\LoggerInterface;


class ContactsController extends Controller
{
    public function __construct(
        protected Mustache $mustache,
        protected LoggerInterface $logger,
    ) 
    {}

    public function contacts(Request $request): string
    {
        $this->logger->info("CONTACTS");

        $search = $request->query->get('q');

        $token = csrf_token(); //$request->session()->token();

        $contacts;

        if($search)
        {
            $contacts = Contact::where("first", "LIKE", $search."%")
                ->orwhere("last", "LIKE", $search."%")
                ->get();
        }
        else
        {
            $contacts = Contact::all();
        }

        $count = Contact::count();

        $this->logger->info($contacts);

        return  $this->mustache->render( 'index.tpl', [
            "contacts" => $contacts,
            "count" => $count,
            "token" => $token
        ]);

    }

    public function count(Request $request): string
    {
        $this->logger->info("COUNT");

        $count = Contact::count();

        return $count;
    }

    public function show(string $id): string
    {

        $this->logger->info("SHOW");

        $contact = Contact::find($id);

        return  $this->mustache->render( 'show.tpl', $contact );
    }

    public function email(Request $request,string $id): string
    {
        $email = $request->get("email");

        $this->logger->info("EMAIL");

        $existing = Contact::where('email', $email)->first();

        if($existing)
        {
            if($existing->id != $id)
            {
                return "Email already taken!";
            }
        }
        return  "";
    }

    public function create(Request $request): string
    {

        $this->logger->info("CREATE");

        $token = csrf_token(); 

        return  $this->mustache->render( 'new.tpl', [
            "contact" => null,
            "token" => $token
        ] );
    }

    public function insert(Request $request): string
    {
        $email = $request->get("email");
        $first = $request->get("first_name");
        $last = $request->get("last_name");
        $phone = $request->get("phone");

        $this->logger->info("INSERT ".$email);

        $contact = new Contact();
        $contact->email = $email;
        $contact->first = $first;
        $contact->last = $last;
        $contact->phone = $phone;

        $errors = array();
        if(!$email)
        {
            $errors["email"] = "Email is required.";
        }
        if(!$first)
        {
            $errors["first"] = "First name is required.";
        }

        $existing = Contact::where('email', $email)->first();

        if($existing)
        {
            $errors["email"] = "Email must be unique.";
        }

        if(count($errors))
        {
            $token = csrf_token(); 

            $viewdata = array(                
                "errors" => $errors,
                "contact" => $contact,
                "token" => $token
            );
    
            return $this->mustache->render("new.tpl",$viewdata);
        }        

        $contact->save();

        return redirect("/contacts");
    }

    public function edit(Request $request, $id): string
    {
        $this->logger->info("EDIT");

        $contact = Contact::find($id);

        $token = csrf_token(); 

        return  $this->mustache->render( 'edit.tpl', [
            "contact" => $contact,
            "token" => $token
        ] );
    }


    public function update(Request $request, $id): string
    {
        $email = $request->get("email");
        $first = $request->get("first_name");
        $last = $request->get("last_name");
        $phone = $request->get("phone");

        $this->logger->info("UPDATE ".$email);

        $contact = Contact::find($id);

        $contact->email = $email;
        $contact->first = $first;
        $contact->last = $last;
        $contact->phone = $phone;

        $errors = array();
        if(!$email)
        {
            $errors["email"] = "Email is required.";
        }
        if(!$first)
        {
            $errors["first"] = "First name is required.";
        }

        $existing = Contact::where('email', $email)->first();

        if($existing && $existing->id != $id )
        {
            $errors["email"] = "Email must be unique.";
        }

        if(count($errors))
        {
            $token = csrf_token(); 

            $viewdata = array(                
                "errors" => $errors,
                "contact" => $contact,
                "token" => $token
            );
    
            return $this->mustache->render("edit.tpl",$viewdata);
        }        

        $contact->save();

        return redirect("/contacts");
    }

    public function remove(Request $request, string $id)
    {

        $this->logger->info("DELETE: ".$id);

        $contact = Contact::find($id);
        $contact->delete();

        if( $request->headers->get('HX-Trigger') == 'delete-btn')
            return redirect('/contacts', 303);

        return response("")
            ->header('HX-Trigger', "recountEvent");
    }

}
