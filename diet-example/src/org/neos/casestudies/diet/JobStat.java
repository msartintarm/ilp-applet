package org.neos.casestudies.diet;

/**
 * Diet problem job statistic
 */

public class JobStat {
	public static final int SUBMITTED = 0;
	public static final int DONE = 1;

	private String jobNumber;
	private String jobPassword;
	private boolean feasible;

	private int status = SUBMITTED;

	private String totalCost;

	public String getJobNumber() {
		return jobNumber;
	}

	public void setJobNumber(String jobNumber) {
		this.jobNumber = jobNumber;
	}

	public String getJobPassword() {
		return jobPassword;
	}

	public void setJobPassword(String jobPassword) {
		this.jobPassword = jobPassword;
	}

	public boolean isFeasible() {
		return feasible;
	}

	public void setFeasible(boolean feasible) {
		this.feasible = feasible;
	}

	public String getTotalCost() {
		return totalCost;
	}

	public void setTotalCost(String totalCost) {
		this.totalCost = totalCost;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

}
