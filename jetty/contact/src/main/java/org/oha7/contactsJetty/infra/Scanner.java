package org.oha7.contactsJetty.infra;

import java.io.IOException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;


public class Scanner {

	private static HashMap<String, ArrayList<String>> classNames = new HashMap<String,ArrayList<String>>();

    public static ArrayList<String> getClassNamesFromPackage(String packageName) throws IOException, java.net.URISyntaxException {

		if(classNames.containsKey(packageName)) return classNames.get(packageName);

		var classes = findClassNamesFromPackage(packageName);
		classNames.put(packageName, classes);
		return classes;
    }

    private static ArrayList<String> findClassNamesFromPackage(String packageName) throws IOException, java.net.URISyntaxException {

        ArrayList<String> result = new ArrayList<String>();

        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();

        String packagePath = packageName.replace(".", "/");
        URL packageURL = classLoader.getResource(packagePath);

        if(packageURL != null && packageURL.getProtocol().equals("jar")){

            String jarFileUrl = URLDecoder.decode(packageURL.getFile(), "UTF-8");
            String jarFilePath = jarFileUrl.substring(5,jarFileUrl.indexOf("!"));
            JarFile jarFile= new JarFile(jarFilePath);

            Enumeration<JarEntry> jarEntries = jarFile.entries();
            while(jarEntries.hasMoreElements())
            {
                String entryName = jarEntries.nextElement().getName();
                if(entryName.startsWith(packagePath) && entryName.endsWith(".class") ) {   

                    entryName = entryName.replace("/",".").replace(".class", "");
                    result.add(entryName);
                }
            }

            jarFile.close();
        }

        return result;
    }

}
