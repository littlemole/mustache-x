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
				int type = metaData.getColumnType(i+1);

				try {
					Field field = clazz.getField(label);
					setField(t,field,resultSet,type,i+1);
				} catch (NoSuchFieldException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			return t;
		} catch (InstantiationException | IllegalAccessException | IllegalArgumentException | InvocationTargetException
				| NoSuchMethodException | SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} 
	}

	private static <T> void setField(T t,Field field, ResultSet resultSet, int type, int column) throws IllegalArgumentException, IllegalAccessException, SQLException {

		switch(type) {

			case java.sql.Types.BIGINT : {
				field.set(t,resultSet.getLong(column));
				break;
			}
			case java.sql.Types.BOOLEAN : {
				field.set(t,resultSet.getBoolean(column));
				break;
			}
			case java.sql.Types.CHAR : {
				field.set(t,resultSet.getByte(column));
				break;
			}
			case java.sql.Types.DATE : {
				field.set(t,resultSet.getDate(column));
				break;
			}
			case java.sql.Types.DECIMAL : {
				field.set(t,resultSet.getBigDecimal(column));
				break;
			}
			case java.sql.Types.DOUBLE : {
				field.set(t,resultSet.getDouble(column));
				break;
			}
			case java.sql.Types.FLOAT : {
				field.set(t,resultSet.getFloat(column));
				break;
			}
			case java.sql.Types.SMALLINT :
			case java.sql.Types.INTEGER : {
				field.set(t,resultSet.getInt(column));
				break;
			}
			case java.sql.Types.LONGNVARCHAR : 
			case java.sql.Types.NCHAR:
			case java.sql.Types.NVARCHAR:
			case java.sql.Types.VARCHAR:
			case java.sql.Types.LONGVARCHAR:
			{
				field.set(t,resultSet.getString(column));
				break;
			}
			case java.sql.Types.NULL :
			{
				field.set(t,null);
				break;
			}
			case java.sql.Types.NUMERIC :
			{
				field.set(t,resultSet.getDouble(column));
				break;
			}
			case java.sql.Types.TIMESTAMP :
			case java.sql.Types.TIMESTAMP_WITH_TIMEZONE:
			{
				field.set(t,resultSet.getTimestamp(column));
				break;
			}
			case java.sql.Types.TINYINT:
			{
				field.set(t,resultSet.getByte(column));
				break;
			}
			default : {
				System.out.println("NOT FOUND " + String.valueOf(type));
				field.set(t,resultSet.getString(column));
			}
		}
	}
}
