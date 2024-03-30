package org.oha7.contactsJetty;

import java.lang.annotation.ElementType;
import java.lang.annotation.Repeatable;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.eclipse.jetty.http.HttpMethod;

@Repeatable(Actions.class)
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Action {
    String value() default "/";
    HttpMethod method() default HttpMethod.GET;
}
