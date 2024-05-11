package org.oha7.contactsJetty.infra;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import java.sql.ResultSet;
import java.sql.SQLException;

public class JDBCmapper {

	public static <T> List<T> mapAll(ResultSet resultSet, Class<T> clazz) throws SQLException {

		List<T> result = new ArrayList<T>();

        while (resultSet.next()) {
            T t = doMap(resultSet, clazz);
            result.add(t);
        }
        return result;
	}

	public static <T> T mapOne(ResultSet resultSet, Class<T> clazz) throws SQLException {

		if(!resultSet.next()) return null;

		return doMap(resultSet,clazz);
	}

	private static <T> T doMap(ResultSet resultSet, Class<T> clazz) throws SQLException {

		try {
			T t = clazz.getDeclaredConstructor().newInstance();

			var metaData = resultSet.getMetaData();
			for(int i = 0; i < metaData.getColumnCount(); i++) {
				String label = metaData.getColumnLabel(i+1);

				try {
					Field field = clazz.getField(label);
					var type = field.getType();
					field.set(t,resultSet.getObject(i+1,type));
			
				} catch (NoSuchFieldException e) {
					// skip over if not there
				}
			}

			return t;
		} catch (InstantiationException | IllegalAccessException | IllegalArgumentException | InvocationTargetException
				| NoSuchMethodException | SecurityException e) {
			e.printStackTrace();
			return null;
		} 
	}
}
