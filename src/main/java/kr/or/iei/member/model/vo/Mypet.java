package kr.or.iei.member.model.vo;

public class Mypet {
	private int petNo;
	private int userNo;
	private String petName;
	private String petGender;
	private String petType;
	private String breedType;
	public Mypet() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Mypet(int petNo, int userNo, String petName, String petGender, String petType, String breedType) {
		super();
		this.petNo = petNo;
		this.userNo = userNo;
		this.petName = petName;
		this.petGender = petGender;
		this.petType = petType;
		this.breedType = breedType;
	}
	public int getPetNo() {
		return petNo;
	}
	public void setPetNo(int petNo) {
		this.petNo = petNo;
	}
	public int getUserNo() {
		return userNo;
	}
	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}
	public String getPetName() {
		return petName;
	}
	public void setPetName(String petName) {
		this.petName = petName;
	}
	public String getPetGender() {
		return petGender;
	}
	public void setPetGender(String petGender) {
		this.petGender = petGender;
	}
	public String getPetType() {
		return petType;
	}
	public void setPetType(String petType) {
		this.petType = petType;
	}
	public String getBreedType() {
		return breedType;
	}
	public void setBreedType(String breedType) {
		this.breedType = breedType;
	}
	@Override
	public String toString() {
		return "Mypet [petNo=" + petNo + ", userNo=" + userNo + ", petName=" + petName + ", petGender=" + petGender
				+ ", petType=" + petType + ", breedType=" + breedType + "]";
	}
	
	
	
}
