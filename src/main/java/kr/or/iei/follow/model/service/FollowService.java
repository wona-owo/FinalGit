package kr.or.iei.follow.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.follow.model.dao.FollowDao;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.member.model.vo.Mypet;

@Service("followService")
public class FollowService {

	@Autowired
	@Qualifier("followDao")
	private FollowDao followDao;

	//팔로우되어있는 관계인지 확인
	public int selectCheckFollor(int followUserNo, int followedUserNo) {
		
		HashMap<String, Object> check = new HashMap<String, Object>();
		check.put("follow", followUserNo); //팔로우하는 사람
		check.put("followed", followedUserNo); //팔로우 당하는 사람
		
		return followDao.selectCheckFollor(check);
	}
	//팔로우 
	public int insertfollow(int followUserNo, int followedUserNo) {
		HashMap<String, Object> insert = new HashMap<String, Object>();
		insert.put("follow", followUserNo); //팔로우하는 사람
		insert.put("followed", followedUserNo); //팔로우 당하는 사람
		
		return followDao.insertFollow(insert);
	}
	//언팔로우
	public int deleteFollow(int myNo, int targetNo) {
		 HashMap<String, Object> deleteMap = new HashMap<>();
		 deleteMap.put("followerNo", myNo);
	     deleteMap.put("followingNo", targetNo);
	     return followDao.deleteFollow(deleteMap);
	}
	
	//맞팔 여부
	public boolean isFollowingEachOther(int myNo, int targetNo) {
		int ab = selectCheckFollor(myNo, targetNo); // A -> B
	    int ba = selectCheckFollor(targetNo, myNo); // B -> A
	    
	    return (ab > 0 && ba > 0);
	}
	
	public int getFollowerCount(int userNo) {
        return followDao.selectFollowerCount(userNo);
    }

    public int getFollowingCount(int userNo) {
        return followDao.selectFollowingCount(userNo);
    }

    public ArrayList<Member> recommendFriends(int userNo) {
        ArrayList<String> myPetTypes = (ArrayList<String>) followDao.getMyPetTypes(userNo);
        
        if (myPetTypes == null || myPetTypes.isEmpty()) {
            return new ArrayList<>(); // 빈 리스트 반환
        }
        
        HashMap<String, Object> params = new HashMap<>();
        params.put("petTypeList", myPetTypes);
        params.put("myUserNo", userNo);
        
        ArrayList<Member> recommendList = (ArrayList<Member>) followDao.getRecommendUsers(params);
        
        for (Member member : recommendList) {
            boolean following = checkIfFollowing(userNo, member.getUserNo());
            member.setFollowing(following);
            
            // 반려동물 정보 추가
            ArrayList<Mypet> pets = (ArrayList<Mypet>)followDao.getPetsByUserNo(member.getUserNo());
            if (!pets.isEmpty()) {
                Mypet pet = pets.get(0); // 첫 번째 반려동물 정보 사용
                member.setPetType(pet.getPetType());
                member.setBreedType(pet.getBreedType());
            }
        }
        
        return recommendList;
    }
    
    // **팔로우 상태 확인 메소드 추가**
    private boolean checkIfFollowing(int userNo, int targetUserNo) {
    	HashMap<String, Object> check = new HashMap<>();
        check.put("follow", userNo);
        check.put("followed", targetUserNo);
        int count = followDao.selectCheckFollor(check);
        return count > 0;
    }
    
    //팔로워 목록 조회 (페이징)
    public List<Member> getFollowers(int userNo, int page, int limit) {
        int start = (page - 1) * limit;
        int end = page * limit;
        
        HashMap<String, Object> loadpage = new HashMap<>();
        loadpage.put("userNo", userNo);
        loadpage.put("start", start);
        loadpage.put("end", end);
        
        return followDao.selectFollowers(loadpage);
    }

    //팔로잉 목록 조회 (페이징)
    public List<Member> getFollowings(int userNo, int page, int limit) {
        int start = (page - 1) * limit;
        int end = page * limit;
        
        HashMap<String, Object> loadpage = new HashMap<>();
        loadpage.put("userNo", userNo);
        loadpage.put("start", start);
        loadpage.put("end", end);
        
        return followDao.selectFollowings(loadpage);
    }
}
