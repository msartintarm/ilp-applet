import java.util.Vector;
import org.apache.xmlrpc.XmlRpcException;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultReceiver;
import org.neos.client.ResultCallback;

class NeosResponse implements ResultCallback {

    public void handleJobInfo (int job_num, String passwd) {
	System.out.println("Job " + job_num + " submitted. Password: " + passwd);
    }
    public void handleFinalResult (String results) {
	System.out.println("Result follows:\n " + results);
    }
}

/*
  Temporary main class designed to test the NEOS server's capability.
  - The giant string represents a complete GAMS model of a spatial architecture.
  - Success here means another giant string (a solution) will be returned from the server.
  Next step: think about duplicating this in Javascript?
*/  
public class Neos {

    static final String the_model = 
"Set K \"Kinds of Node or Vertice\" /IN, OUT, ADD, SUB, MULT, DIV/;\n" +
"* Software Vertices / Edges\n" +
"Set v \"Vertices\"   /v1, v2, v3, v4, v5, v6/;\n" +
"Set e \"Edges\"      /e1, e2, e3, e4, e5/;\n" +
"\n" +
"* Vertice / Edge Connections\n" +
"Parameter Gve(v,e)       /v1.e1 1, v2.e2 1, v3.e3 1, v4.e4 1, v5.e5 1/;\n" +
"Parameter Gev(e,v)       /e1.v4 1, e2.v4 1, e3.v5 1, e4.v5 1, e5.v6 1/;\n" +
"\n" +
"* Delta for non-specified edges (e1 - e3) is 0\n" +
"parameter delta(e) /e4 1, e5 3/;\n" +
"\n" +
"* Kinds of Vertices\n" +
"Set KindV(K,v)     /IN.v1, IN.v2, IN.v3, MULT.v4, DIV.v5, OUT.v6/;\n" +
"* Hardware Nodes / Links\n" +
"Set n \"Nodes\"   /n1 * n8/;\n" +
"Set r \"Routers\" /r1 * r4/;\n" +
"Set l \"Links\"   /l1 * l20/;\n" +
"\n" +
"* Node Connections\n" +
"Set Hnl(n,l) /n1.l1, n2.l3, n3.l5, n5.l13, n7.l18, n8.l20/;\n" +
"Set Hln(l,n) /l2.n1, l4.n2, l7.n4, l15.n6, l17.n7, l19.n8/;\n" +
"\n" +
"* Router Connections\n" +
"Set Hrl(r,l) /r1.l2, r1.l6, r1.l9, \n" +
"    	      r2.l4, r2.l7, r2.l8, r2.l11,\n" +
"	      r3.l10, r3.l14, r3.l17,\n" +
"	      r4.l12, r4.l15, r4.l16, r4.l18/;\n" +
"Set Hlr(l,r) /l1.r1, l5.r1, l8.r1, l10.r1,\n" +
"    	      l3.r2, l8.r2, l12.r2,\n" +
"	      l9.r3, l13.r3, l16.r3, l18.r3,\n" +
"	      l11.r4, l14.r4, l20.r4/;\n" +
"\n" +
"* Kinds of Operational Nodes\n" +
"Set kindN(K,n)  /IN.n3, IN.n5, MULT.n1, ADD.n2, SUB.n2, \n" +
"     	         ADD.n7, SUB.n7, DIV.n8, OUT.n4, OUT.n6/;\n" +
"variable\n" +
"	cost, LAT, SVC;\n" +
"binary variable\n" +
"    Mvn(v,n), Mel(e,l), Mvl(v,l);\n" +
"positive variable   \n" +
"    Tv(v), Te(e), O(l), extra(e), Wn(n);\n" +
"\n" +
"\n" +
"* Setup Aliases, and alternate ways of viewing inputs\n" +
"alias(v1,v2,v);\n" +
"set Gvv(v,v);\n" +
"Gvv(v1,v2)=YES$(sum(e,Gve(v1,e) and Gev(e,v2))); \n" +
"alias (l1,l2,l);\n" +
"set Hll(l,l);\n" +
"Hll(l1,l2)=YES$( sum(n,Hln(l1,n) and Hnl(n,l2)) or \n" +
"         (sum(r,Hlr(l1,r) and Hrl(r,l2)) and not sum(n,Hnl(n,l1) and Hln(l2,n))) );\n" +
"Equations \n" +
"  c1_map_all_v(K,v), c2_map_valid(K,v), c3_map_edge_src(v,e,n), c4_map_edge_dst(e,v,n)\n" +
"  c5_router_fwd(e,r), c6_timing(v,e,v), c7_max_cycle(v), c8_work_effort(n),\n" +
"  c9_calc_svc(n), c10_unique_router_source(e,r),\n" +
"  c21_bundle_edges(v,e,l), c22_bundle_edges_alt(v,l), c23_link_throughput(l)\n" +
"  objective;\n" +
"    \n" +
"c1_map_all_v(K,v)$kindV(K,v)..          sum(n$(kindN(K,n)),     Mvn(v,n)) =e= 1;\n" +
"c2_map_valid(K,v)$kindV(K,v)..          sum(n$(not kindN(K,n)), Mvn(v,n)) =e= 0;\n" +
"c3_map_edge_src(v,e,n)$Gve(v,e)..       Mvn(v,n) =e= sum(l$Hnl(n,l), Mel(e,l));\n" +
"c4_map_edge_dst(e,v,n)$(Gev(e,v))..     Mvn(v,n) =e= sum(l$Hln(l,n), Mel(e,l));\n" +
"c5_router_fwd(e,r).. sum(l$Hlr(l,r),Mel(e,l)) =e= sum(l$Hrl(r,l), Mel(e,l));\n" +
"c6_timing(v1,e,v2)$(Gve(v1,e) and Gev(e,v2))..\n" +
"    Tv(v2) =e= Tv(v1) + sum(l,Mel(e,l)) + delta(e) + extra(e);\n" +
"c7_max_cycle(v)$(sum(e,Gve(v,e))=0).. LAT =g= Tv(v);\n" +
"c8_work_effort(n).. sum(v, Mvn(v,n)) =e= Wn(n);\n" +
"c9_calc_svc(n).. SVC =g= Wn(n);\n" +
"\n" +
"\n" +
"\n" +
"c10_unique_router_source(e,r).. sum(l$Hlr(l,r),Mel(e,l)) =l= 1;\n" +
"\n" +
"c21_bundle_edges(v,e,l)$(Gve(v,e))..    Mel(e,l) =l= Mvl(v,l);\n" +
"c22_bundle_edges_alt(v,l)..             sum(e$(Gve(v,e)),Mel(e,l)) =g= Mvl(v,l);\n" +
"c23_link_throughput(l)..                sum(v,Mvl(v,l)) =l= 1;model problem1 \"Incorporates basic constraints\"\n" +
"      /c1_map_all_v, \n" +
"	   c2_map_valid, \n" +
"	   c3_map_edge_src,\n" +
"	   c4_map_edge_dst,\n" +
"	   c5_router_fwd,\n" +
"	   c6_timing,\n" +
"	   c7_max_cycle,\n" +
"	   c8_work_effort,\n" +
"	   c9_calc_svc/;\n" +
"solve problem1 using mip minimizing SVC;\n" +
"\n" +
"Equation objective \"Service Interval Constraint\";\n" +
"objective.. SVC =e= SVC.l;	\n" +
"model problem2 \"Constrains service interval to <= 1\"\n" +
"      /c1_map_all_v, \n" +
"	   c2_map_valid, \n" +
"	   c3_map_edge_src,\n" +
"	   c4_map_edge_dst,\n" +
"	   c5_router_fwd,\n" +
"	   c6_timing,\n" +
"	   c7_max_cycle,\n" +
"	   c8_work_effort,\n" +
"	   c9_calc_svc,\n" +
"	   objective/;\n" +
"solve problem2 using mip minimizing LAT;\n" +
"\n" +
"\n" +
"file outfile / \"solution.lst\" /;\n" +
"outfile.pc=8;\n" +
"outfile.pw=4096;\n" +
"put outfile;\n" +
"\n" +
"put \"Vertex : Node  Mapping\" /\n" +
"loop(v,\n" +
"    put v.tl \":\";\n" +
"    loop((n)$(Mvn.l(v,n)<>0),\n" +
"        put n.tl\n" +
"    );\n" +
"    put /\n" +
");\n" +
"\n" +
"put / \"Edge : Link  Mapping\" /\n" +
"loop(e,\n" +
"    put e.tl \":\"\n" +
"    loop((l)$(Mel.l(e,l)<>0),\n" +
"        put l.tl\n" +
"    );\n" +
"    put /\n" +
");\n";

    public static void main(String[] args) {

	// Package file into server-sending format
	// .. first by turning it into XML ..
	NeosJobXml the_job = new NeosJobXml("milp", "scip", "CPLEX");
	the_job.addParam("model", the_model);
	// .. and then by putting the XML in a vector.
	Vector<String> the_params = new Vector<String>();
	the_params.add(the_job.toXMLString());

	NeosXmlRpcClient the_client = new NeosXmlRpcClient("www.neos-server.org", "3332");

	Object[] solvers;
	Object[] results;

	try {
	    // Connect to server
	    the_client.connect();

	    Vector<String> solver_params = new Vector<String>();
	    solver_params.add("milp");
	    // Print out all the solvers we can use in MILP.
	    solvers = (Object[])the_client.execute("listSolversInCategory",
						   solver_params,
						   5000);
	    System.out.println("Solvers usable with \"milp\". Solver / input language.");
	    for(int i = 0; i < solvers.length; ++i) {
		System.out.print(solvers[i] + " ");
	    }
	    System.out.print("\n");
	    System.out.print(the_params.toString());

	    // Submit to NEOS, waiting 5 secs for job ID / password
	    results = (Object[])the_client.execute("submitJob",
						    the_params,
						   5000);
	    Integer job_num = (Integer) results[0];
	    String job_pass = (String) results[1];
	    System.out.println("submitted. Job number: " + job_num + ", job password: " + job_pass);

	    NeosResponse the_response = new NeosResponse(); // implements an asynchronous interface

	    // This class will handle callback in its own thread. I think it checks every 100 ms.
	    ResultReceiver receiver = new ResultReceiver(the_client, the_response, job_num, job_pass);
	    receiver.start();

	    // Boom goes the dynamite.

	} catch (XmlRpcException e) {
	    System.err.println("Uh-oh.. error! " + e);
	}
    }
}


