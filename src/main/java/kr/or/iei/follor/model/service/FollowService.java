package kr.or.iei.follor.model.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.follor.model.dao.FollowDao;

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
}
