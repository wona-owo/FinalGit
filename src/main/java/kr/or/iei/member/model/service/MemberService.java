package kr.or.iei.member.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.dao.MemberDao;
import kr.or.iei.member.model.vo.HashTag;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.member.model.vo.Mypet;
import kr.or.iei.member.model.vo.Search;
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

	public ArrayList<Member> searchUser(String search) { //키워드 입력시 실시간으로 관련 유저 보여줌
		// TODO Auto-generated method stub
		return (ArrayList<Member>)memberDao.searchUser(search);
	}

	public ArrayList<HashTag> searchTag(String searchStr) { //키워드 입력시 실시간으로 관련 해시태그 보여줌
		// TODO Auto-generated method stub
		return (ArrayList<HashTag>)memberDao.searchTag(searchStr);
	}
	public List<HashTag> searchHashTagsKeyword(String search, int page, int pageSize) { //키워드와 관련된 해시태그 목록 가져오는거
		// TODO Auto-generated method stub
		int start = (page - 1) * pageSize;
		int end = page * pageSize;

		HashMap<String, Object> paramMap = new HashMap<>();
		paramMap.put("search", search);
		paramMap.put("start", start);
		paramMap.put("end", end);
		return memberDao.searchHashTagsKeyword(paramMap);
	}
	
	public List<Member> searchUsersKeyword(String search, int page, int pageSize) { //키워드와 관련된 유저 목록 가져오는거
		int start = (page - 1) * pageSize;
        int end   = page * pageSize;

        HashMap<String, Object> paramMap = new HashMap<>();
        paramMap.put("search", search);
        paramMap.put("start", start);
        paramMap.put("end", end);
		return memberDao.searchUsersKeyword(paramMap);
	}
	
	public int checkKeyword(int userNo, String search) { //중복되는 값 체크
		HashMap<String, Object> check = new HashMap<>();
	    check.put("userNo", userNo);
	    check.put("keyword", search);
	    return memberDao.checkKeyword(check);
	}

	public int updateKeywordDate(int userNo, String searchType, String userId, String search) { // 날짜만 업데이트
		HashMap<String, Object> update = new HashMap<>();
		update.put("userNo", userNo);
		update.put("searchType", searchType);
		update.put("userId", userId);
		update.put("keyword", search);
		return memberDao.updateKeywordDate(update);

	}
	
	public int insertKeyword(int userNo, String searchType, String userId, String search) { // 새롭게 등록
		HashMap<String, Object> insert = new HashMap<>();
		insert.put("userNo", userNo);
		insert.put("searchType", searchType);
		insert.put("userId", userId);
		insert.put("keyword", search);
		return memberDao.insertKeyword(insert);
	}

	public int deleteKeyword(int userNo, String keyword) { // 중복되는 값 삭제
		HashMap<String, Object> delete = new HashMap<>();
		delete.put("userNo", userNo);
		delete.put("keyword", keyword);
		return memberDao.deleteResultKeyword(delete);

	}
	
	public ArrayList<HashTag> selectKeywordTag(String hashName) {
		return (ArrayList<HashTag>)memberDao.selectKeywordTag(hashName);
	}
	
	public Member selectKeywordUser(String userName) {
		// TODO Auto-generated method stub
		return memberDao.selectKeywordUser(userName);
	}
	
	public HashTag selectTagName(String hashName) {
		return memberDao.selectTagName(hashName);
	}
	
	public int updateSearchHistory(int userNo, String searchType, String search) {
		HashMap<String, Object> update = new HashMap<>();
		update.put("userNo", userNo);
		update.put("keyword", search);
		update.put("searchType", searchType);
		return memberDao.updateSearchHistory(update);
	}
	
	public ArrayList<Search> selectSearchHistoryList(int userNo) {
		// TODO Auto-generated method stub
		return (ArrayList<Search>)memberDao.selectSearchHistoryList(userNo);
	}
	public int deleteSearchHistory(int userNo, String search, String searchType) {
		HashMap<String, Object> delete = new HashMap<>();
		delete.put("userNo", userNo);
		delete.put("search", search);
		delete.put("searchType", searchType);
		return memberDao.deleteSearchHistory(delete);
	}
	
	public int deleteAllSearchHistory(int userNo) {
		// TODO Auto-generated method stub
		 return memberDao.deleteAllSearchHistory(userNo); // DAO 호출
	}

	public int userDelete(String userId) {
		return memberDao.userDelete(userId);
	}

	public int updateProfile(Member member) {
		return memberDao.updateProfile(member);
	}

	public int updatePassword(Member chkMember) {
		return memberDao.updatePassword(chkMember);
	}

	public int selectUser(String userId) { //유저 No 검색
		// TODO Auto-generated method stub
		return memberDao.selectUserNo(userId);
	}

	// 아이디 찾기
	public String findUserId(String email, String phone) {
		HashMap<String, String> params = new HashMap<>();
		params.put("email", email);
		params.put("phone", phone);
		return memberDao.findUserId(params);
	}

	public String selectPwUser(String userId, String email) {
		HashMap<String, String> params = new HashMap<>();
		params.put("userId", userId);
		params.put("email", email);
		return memberDao.selectPwUser(params);
	}

	public int replaceMemberPw(String userId, String newPw) {
		Member member = new Member();
		member.setUserId(userId);
		member.setUserPw(newPw); // 새 비밀번호 설정
		return memberDao.updatePassword(member); // DAO 호출
	}

	public ArrayList<String> selectBreedType(String petType) {
        return (ArrayList<String>) memberDao.selectBreedType(petType);
    }

    public ArrayList<Mypet> selectMypet(String userNo) {
        return (ArrayList<Mypet>) memberDao.selectMypet(userNo);
    }

    public int dupChkMypet(Mypet mypet) {
        return memberDao.dupChkMypet(mypet);
    }

    public int overChkMypet(Mypet mypet) {
        return memberDao.overChkMypet(mypet);
    }
    
    public int insertMypet(Mypet mypet) {
        return memberDao.insertMypet(mypet);
    }

    public int deleteMypet(Mypet mypet) {
        return memberDao.deleteMypet(mypet);
    }

    public int updateMypet(Mypet mypet) {
        return memberDao.updateMypet(mypet);
    }
    
    //2025-01-01 장승원 추가
    //selectMypet은 String이라 다른 매소드 선언
    //내가 키우는 동물 리스트
	public ArrayList<Mypet> selectMyPetList(int userNo) {
		// TODO Auto-generated method stub
		return (ArrayList<Mypet>)memberDao.selectMyPetList(userNo);
	}


	public ArrayList<Member> selectUserImages(ArrayList<String> userIds) {
		// TODO Auto-generated method stub
		return (ArrayList<Member>) memberDao.selectUserImages(userIds);
	}

	public Member searchUserData(int userNo) {
		// TODO Auto-generated method stub
		return memberDao.searchUserData(userNo);
	}

	
}
