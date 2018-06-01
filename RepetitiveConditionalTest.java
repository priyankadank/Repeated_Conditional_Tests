package javaSamples.bugCor112;
public class RepetitiveConditionalTest {
 
 
	int x;
	int y;
	String result; 
	   
	
	void findRpc_inIf_inDisjunction_onField() 
	{
		if (x == 0 || x == 0)
		{
			result = "Error  Repeated Contional Test"; 
		}
		else if (x == 0 || x == 0)
		{ 
			result = "Error  Repeated Contional Test";
		}
	}
	
	void findRpc_inIf_inDisjunction_onLocal()  
	{
		int x=0,y=0;
		if (x == 10 || x == 10)
		{
			result = "Error Repeated Contional Test";
		}
		if(x==y || x==y)
		{
		}
		
	}
	
	void findRpc_inIf_inDisjunction_onParameter(int x)
	{
		if (x == 10 || x == 10)
		{
			result = "Error  Repeated Contional Test";
		}
	}
	
	void findRpc_inIf_inConjunction_onField()
	{
		if (x == 0 && x == 0)
		{
			result = "Error  Repeated Contional Test"; 
		}
		else if (x == 0 && x == 0)
		{
			result = "Error  Repeated Contional Test";
		}
	}

	
	void findRpc_inWhile_inDisjunction_onParameter(int x)
	{
		while (x == 10 || x == 10) 
		{
			result = "Error  Repeated Contional Test";
		}
	} 
	
	// This is a case that is NOT found by the current implementation, unfortunately:
	void findRpc_inWhile_nested(int x)
	{
		while ( (this.x == 20 || this.x == 20) && (x == 10 || x == 10) )
		{
			result = "Error  Repeated Contional Test";
		}
	} 

    // Don't find conditions that are identical but occur nested in different
	// logical operators (here: x==10 is NOT a duplicate!)
	void DONTfindRpc_inWhile_nested(int x)
	{
		while ( (x == 10 || this.x == 20) && (x == 10 || this.x == 30) )
		{
			result = "Error  Repeated Contional Test";
		}
	} 


    // The following is logically still a case of repeated condition
	// because (x == 10 || this.x == 20) would suffice.
	// However, detecting such cases is too complex to be treated in the lab:
	void find_entire_repeated_subconditions(int x)
	{
		while ( (x == 10 || this.x == 20) && (x == 10 || this.x == 20) )
		{
			result = "Error  Repeated Contional Test";
		}
	} 

	
	void findRpc_inIf_inDisjunction_onArray()  
	{
		int[] array1 ={1,2,3};    
		int[] array2 ={4,5,6};    
		int x= 3;      
		            
		if(array1.length == 3 ||                       
		   array1.length <x ||                       
		   array1.length == 3 ||                             
		   array2.length<x ||           
		   array1.length <x||array1.length==array2.length)      
		{  
			result = "error";   
		}      
		    
		if(array1.length == 3 || array2.length == 3)
		{   
			result = "error"; 
		} 
		
 
	}    
	     
	void findRpc_inDowhile_inDisjunction_onField() 
	{  
		 
		do     
		{  
			result = "Error  Repeated Conditional Test";
		}   
		 while (x == 10 || x == 10);
	}
	
	/* ==== FALSE POSITIVES (don't find any of these) ==== */
	
	void dontfindRpc()
	{
		if (x == 10 || y == 10)
		{
			result = "Good: No Repeated Conditional Test";
		}
	}
	
	void dontfindRpc1()
	{
		int x=0;
		if (x == 10 || y == 10)
		{
			result = "Good: No Repeated Contional Test";
		}
	}
	
	void dontfindRpc2(int x)
	{
		if (x == 10 || y == 10)
		{
			result = "Good: No Repeated Contional Test";
		}
	}
	
	void dontfindRpc3()
	{
		if (x == 0 && y == 0)
		{
			result = "Good: No Repeated Contional Test"; 
		}
		else if (x == 0 && y == 0) 
		{
			result = "Good: No Repeated Contional Test";
		}
	}

} 