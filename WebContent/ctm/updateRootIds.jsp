<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.lang.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%

Class.forName("com.mysql.jdbc.Driver").newInstance();

/**
 * UpdateRootIds fixes the aggregator.transaction_header table so that 
 * all related transaction share a common rootId.  This is need for the
 * comments section as they can be linked to any number of transaction
 * id's for a single quote.
 **/
class UpdateRootIds {
	String host	= "qa.ecommerce.disconline.com.au";
	String db	= "aggregator";
	String tbl	= "transaction_header";
	String user = "server";
	String pass = "server";
	String conn;
	Connection Conn;
	
	/**
	 * Constructor() establishing the DB connection and get the ball rolling.
	 **/
	public UpdateRootIds() {
		try{
			conn = "jdbc:mysql://" + host + "/" + db + "?user=" + user + "&password=" + pass;
			Conn = DriverManager.getConnection(conn);
			
			// Kick Off
			start();
		} catch(SQLException e) {
			System.out.println("UpdateRootIds");
			System.out.println(e);
		}
	}
	
	/**
	 * getTranChildren() recursively finds all the child transactions of the parent and updates
	 * their rootId.
	 **/
	private Boolean getTranChildren(int prevId, int rootId) {
		try{
			String Query = "SELECT TransactionId AS tid, rootId FROM " + tbl + " WHERE PreviousId='" + prevId + "'";
			Statement stmnt = Conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
			ResultSet relatives = stmnt.executeQuery(Query);
			
			while(relatives.next())
			{
				int tid = relatives.getInt("tid");
				relatives.updateInt("rootId", rootId);
				relatives.updateRow();
				getTranChildren(tid, rootId);
			}
		
			relatives.close();
			stmnt.close();
		} catch(SQLException e) {
			System.out.println(e);
		}
		
		return true;
	}
	
	/**
	 * start() finds all the parent transactions (PreviousId of zero) and updates its own rootId
	 * then calls getTranChildren to locate and update each child.
	 **/
	public void start() {
		try{
			Statement stmnt = Conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String Query = "SELECT TransactionId AS tid, rootId FROM " + tbl + " WHERE PreviousId='0'";
			ResultSet parents = stmnt.executeQuery(Query);
			
			while(parents.next())
			{
				int tid = parents.getInt("tid");
			    parents.updateInt("rootId", tid);
			    parents.updateRow();
			    getTranChildren(tid, tid);
			}
	
			parents.close();
			stmnt.close();
			Conn.close();
		} catch(SQLException e) {
			System.out.println(e);
		}
	}
}

new UpdateRootIds();


%>