package kr.or.iei.follor.model.vo;

public class Follow {
	private int followingNo; // 팔로우 당하는 사람의 user_no
    private int followerNo;  // 팔로우 하는 사람의 user_no
    private int followingCount; // 팔로잉 수
    private int followerCount;  // 팔로워 수
	public Follow() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Follow(int followingNo, int followerNo, int followingCount, int followerCount) {
		super();
		this.followingNo = followingNo;
		this.followerNo = followerNo;
		this.followingCount = followingCount;
		this.followerCount = followerCount;
	}
	public int getFollowingNo() {
		return followingNo;
	}
	public void setFollowingNo(int followingNo) {
		this.followingNo = followingNo;
	}
	public int getFollowerNo() {
		return followerNo;
	}
	public void setFollowerNo(int followerNo) {
		this.followerNo = followerNo;
	}
	public int getFollowingCount() {
		return followingCount;
	}
	public void setFollowingCount(int followingCount) {
		this.followingCount = followingCount;
	}
	public int getFollowerCount() {
		return followerCount;
	}
	public void setFollowerCount(int followerCount) {
		this.followerCount = followerCount;
	}
	@Override
	public String toString() {
		return "Follow [followingNo=" + followingNo + ", followerNo=" + followerNo + ", followingCount="
				+ followingCount + ", followerCount=" + followerCount + "]";
	}
    
    
}
