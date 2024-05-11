package org.oha7.contactsJetty.infra;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Date;
import java.util.List;


public class Query implements AutoCloseable {

	//    private static String jdbcurl = "jdbc:mariadb://mariadb/contacts?user=contacts&password=contact&useUnicode=true&amp;characterEncoding=UTF-8";

	private static String jdbcurl = System.getProperty("JDBC_URL");

	public Connection conn = null;
	public PreparedStatement stmt = null;
	public ResultSet resultSet = null;

	private int params = 1;

	public Query() {
	}

	public Query prepare(String sql) throws SQLException {

		conn = DriverManager.getConnection(jdbcurl);

		stmt = conn.prepareStatement(sql);

		return this;
	}

	public Query param(String value) throws SQLException {
		stmt.setString(params,value);
		params++;
		return this;
	}

	public Query param(int value) throws SQLException {
		stmt.setInt(params,value);
		params++;
		return this;
	}

	public Query param(long value) throws SQLException {
		stmt.setLong(params,value);
		params++;
		return this;
	}

	public Query param(byte value) throws SQLException {
		stmt.setByte(params,value);
		params++;
		return this;
	}

	public Query param(short value) throws SQLException {
		stmt.setShort(params,value);
		params++;
		return this;
	}

	public Query param(boolean value) throws SQLException {
		stmt.setBoolean(params,value);
		params++;
		return this;
	}

	public Query param(float value) throws SQLException {
		stmt.setFloat(params,value);
		params++;
		return this;
	}

	public Query param(double value) throws SQLException {
		stmt.setDouble(params,value);
		params++;
		return this;
	}

	public Query param(BigDecimal value) throws SQLException {
		stmt.setBigDecimal(params,value);
		params++;
		return this;
	}

	public Query param(Date value) throws SQLException {
		stmt.setDate(params,value);
		params++;
		return this;
	}

	public Query param(Timestamp value) throws SQLException {
		stmt.setTimestamp(params,value);
		params++;
		return this;
	}

	public Query param(Time value) throws SQLException {
		stmt.setTime(params,value);
		params++;
		return this;
	}

	public <T> T queryOne(Class<T> clazz) throws SQLException {

		resultSet = stmt.executeQuery();
		return JDBCmapper.mapOne(resultSet, clazz);
	}

	public <T> List<T> queryAll(Class<T> clazz) throws SQLException {

		resultSet = stmt.executeQuery();
		return JDBCmapper.mapAll(resultSet, clazz);
	}

	public void ecexute() throws SQLException {
		stmt.executeUpdate();
	}

	public <T> T query(Class<T> clazz) throws SQLException {

		resultSet = stmt.executeQuery();

		if(resultSet.next())
		{
			return (T) resultSet.getObject(1,clazz);
		}
		return null;
	}

    public void close() {

        try {
            if (resultSet != null) {
                resultSet.close();
            }

            if (stmt != null) {
                stmt.close();
            }

            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

}
