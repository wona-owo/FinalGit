package kr.or.iei.member.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.member.model.vo.HashTag;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.member.model.vo.Mypet;
import kr.or.iei.member.model.vo.Search;
import kr.or.iei.post.model.vo.Post;

@Repository("dao")
public class MemberDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public int join(Member member) {
		return sqlSession.insert("member.insertUser", member);
	}
	
	public Member memberLogin(Member member) {
		return sqlSession.selectOne("member.loginMember", member);
	}

	public int idDuplChk(String userId) {
		return sqlSession.selectOne("member.idDuplChk", userId);
	}

	public int nickDuplChk(String userNickname) {
		return sqlSession.selectOne("member.nickDuplChk", userNickname);
	}

	public int phoneDuplChk(String userPhone) {
		return sqlSession.selectOne("member.phoneDuplChk", userPhone);
	}

	public int apiJoin(Member member) {
		return sqlSession.insert("member.insertApiUser", member);
	}

	public List<Member> searchUser(String search) { //키워드 입력시 실시간으로 관련 유저 보여줌
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.userSearch", search);
	}

	public List<HashTag> searchTag(String searchStr) { //키워드 입력시 실시간으로 관련 해시태그 보여줌
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.tagSearch", searchStr);
	}
	
	public List<HashTag> searchHashTagsKeyword(String search) { //키워드와 관련된 해시태그 목록 가져오는거
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.searchHashTagsKeyword", search);
	}
	
	public List<Member> searchUsersKeyword(String search) { //키워드와 관련된 유저 목록 가져오는거
		// TODO Auto-generated method stub 
		return sqlSession.selectList("member.searchUsersKeyword", search);
	}
	public int updateKeywordDate(HashMap<String, Object> update) {
		// TODO Auto-generated method stub
		return sqlSession.update("member.updateKeywordDate", update);
	}
	
	public int checkKeyword(HashMap<String, Object> check) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.selectCheckKeyword", check);
	}
	
	public int insertKeyword(HashMap<String, Object> insert) {
		// TODO Auto-generated method stub
		return sqlSession.insert("member.insertKeyword", insert);
	}
	
	public int deleteResultKeyword(HashMap<String, Object> delete) {
		// TODO Auto-generated method stub
		return sqlSession.delete("member.deleteResultKeyword", delete);
	}
	
	public List<HashTag> selectKeywordTag(String hashName) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.keywordTag", hashName);
	}
	
	public Member selectKeywordUser(String userName) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.selectKeywordUser", userName);
	}
	public HashTag selectTagName(String hashName) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.selectTagName", hashName);
	}
	public List<Search> selectSearchHistoryList(int userNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.selectMySearchList", userNo);
	}
	public int updateSearchHistory(HashMap<String, Object> update) {
		// TODO Auto-generated method stub
		return sqlSession.update("member.updateSearchHistory", update);
	}
	
	public int deleteSearchHistory(HashMap<String, Object> delete) {
		// TODO Auto-generated method stub
		return sqlSession.delete("member.deleteSearchHistory", delete);
	}
	
	public int userDelete(String userId) {
		return sqlSession.delete("member.userDelete", userId);
	}

	public int updateProfile(Member member) {
		return sqlSession.update("member.updateProfile", member);
	}

	public int deleteAllSearchHistory(int userNo) {
		// TODO Auto-generated method stub
		return sqlSession.delete("member.deleteAllSearchHistory", userNo);
	}

	public int updatePassword(Member chkMember) {
		return sqlSession.update("member.updatePassword", chkMember);
	}

	public int selectUserNo(String userId) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.selectUserNo", userId);
	}

	// 아이디 찾기
	public String findUserId(HashMap<String, String> params) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.findUserId", params);
	}

	public String selectPwUser(HashMap<String, String> params) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.findUserByIdAndEmail", params);
	}

	public List<String> selectBreedType(String petType) {
        return sqlSession.selectList("member.selectBreedType", petType);
    }

    public List<Mypet> selectMypet(String userNo) {
        return sqlSession.selectList("member.selectMypet", userNo);
    }

    public int dupChkMypet(Mypet mypet) {
        return sqlSession.selectOne("member.dupChkMypet", mypet);
    }
    
    public int overChkMypet(Mypet mypet) {
        return sqlSession.selectOne("member.overChkMypet", mypet);
    }

    public int insertMypet(Mypet mypet) {
        return sqlSession.insert("member.insertMypet", mypet);
    }

    public int deleteMypet(Mypet mypet) {
        return sqlSession.delete("member.deleteMypet", mypet);
    }

    public int updateMypet(Mypet mypet) {
        return sqlSession.update("member.updateMypet", mypet);
    }

	public List<Mypet> selectMyPetList(int userNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.selectMyPetList", userNo);
	}

	//유저 이미지 가져오기
	public List<Member> selectUserImages(ArrayList<String> userIds) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.selectUserImages", userIds);
	}

	public Member searchUserData(int userNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.searchUserData", userNo);
	}

	
}
