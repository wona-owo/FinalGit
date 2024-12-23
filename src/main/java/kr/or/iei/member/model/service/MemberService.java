package kr.or.iei.member.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.dao.MemberDao;
import kr.or.iei.member.model.vo.HashTag;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.vo.Post;

@Service("service")
public class MemberService {
	
	@Autowired
	@Qualifier("dao")
	private MemberDao memberDao;
	
	public int join(Member member) {
		return memberDao.join(member);
	}
	
	public Member memberLogin(Member member) {	
		return memberDao.memberLogin(member);
	}

	public int idDuplChk(String userId) {
		return memberDao.idDuplChk(userId);
	}

	public int nickDuplChk(String userNickname) {
		return memberDao.nickDuplChk(userNickname);
	}

	public int phoneDuplChk(String userPhone) {
		return memberDao.phoneDuplChk(userPhone);
	}

	public int apiJoin(Member member) {
		return memberDao.apiJoin(member);
	}

	public ArrayList<Member> searchUser(String search) {
		// TODO Auto-generated method stub
		return (ArrayList<Member>)memberDao.searchUser(search);
	}

	public ArrayList<HashTag> searchTag(String searchStr) {
		// TODO Auto-generated method stub
		return (ArrayList<HashTag>)memberDao.searchTag(searchStr);
	}

	public int updateKeyword(int userNo, String search) {
		// TODO Auto-generated method stub
	    HashMap<String, Object> searchs = new HashMap<>();
	    searchs.put("userNo", userNo); // 사용자 번호
	    searchs.put("keyword", search); // 검색 키워드
	    
		return memberDao.updateKeyword(searchs);
	}

	public int insertKeyword(int userNo, String search) {
		HashMap<String, Object> insertKey = new HashMap<>();
		insertKey.put("userNo", userNo); // 사용자 번호
		insertKey.put("keyword", search); // 검색 키워드
	    
		return memberDao.insertKeyword(insertKey);
		
	}

	public ArrayList<Member> searchResultUser(String search) {
		// TODO Auto-generated method stub
		return (ArrayList<Member>)memberDao.searchResultUser(search);
	}

	public ArrayList<HashTag> searcResulthTag(String search) {
		// TODO Auto-generated method stub
		return (ArrayList<HashTag>)memberDao.searchResultTag(search);
	}
	
	public int userDelete(String userId) {
		return memberDao.userDelete(userId);
	}

	public ArrayList<HashTag> searchHashTagsKeyword(String search) {
		// TODO Auto-generated method stub
		return (ArrayList<HashTag>)memberDao.searchHashTagsKeyword(search);
	}

	public ArrayList<Member> searchUsersKeyword(String search) {
		return (ArrayList<Member>)memberDao.searchUsersKeyword(search);
	}

}
