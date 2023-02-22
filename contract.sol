// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract project{
    address owner;
    mapping (string =>mapping(address=>bool)) subjectToTeacher;
    mapping(address=>Teacher) teachers;
    mapping (address =>string[]) subjectArray;
    mapping(address => mapping(string => Student)) students;

    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwner{
        require(msg.sender==owner,"NOT ACCESSIBLE BY YOU..YOU ARE NOT THE OWNER!!!!!");
        _;
    }

    struct Teacher{
        address teacherAddress;
        mapping(string=>bool) teachesSubject;

    }
    //strcutre to store students details
    struct Student {
        uint marks;
        string subjectId;
        address updatedby;
        bool hasMarks;
    }


    function addTeacher(string[] memory subjectCode , address teacher) public onlyOwner{
        teachers[teacher].teacherAddress=teacher;
        for(uint i=0;i<subjectCode.length;i++){
            teachers[teacher].teachesSubject[subjectCode[i]]=true;

            subjectToTeacher[subjectCode[i]][teacher]=true;
        }
        subjectArray[teacher]=subjectCode;

    }
    function viewTeacherSubjects(address teacher) public view returns(string[] memory) {
        require(teachers[teacher].teacherAddress==teacher,"Teacher not registered");
        require(subjectArray[teacher].length !=0,"No subjects Assigned");
        return subjectArray[teacher];
        
    }

    function updateMarks(address student,string memory subjectId1,uint marks) public {
        //require(keccak256(abi.encodePacked(teachers[msg.sender].teachesSubject[subjectId]==true,"UNAUTHORIZED ACCESS!!!!!!!!!")));
        require(msg.sender==owner || subjectToTeacher[subjectId1][msg.sender],"ACCESS NOT GRANTED");
        //Student storage studentData=students[student][subjectId1];
        if(!students[student][subjectId1].hasMarks){
            students[student][subjectId1].hasMarks=true;
            students[student][subjectId1].updatedby=msg.sender;
        }else{
            require(students[student][subjectId1].updatedby==msg.sender,"Student marks can only be updated by the teacher who uploaded it for the first time");
        }
        

        // students[student][subjectId1]=Student({
        //     marks:marks,
        //     subjectId:subjectId1,
        //     updatedby:msg.sender
        // });
        students[student][subjectId1].marks=marks;
        students[student][subjectId1].subjectId=subjectId1;
    }

    function viewMarks(address student , string memory subjectId1) public view returns(uint){
        require(msg.sender==owner ||subjectToTeacher[subjectId1][msg.sender] || msg.sender==student, "ACCESS DENIED!!!!" );
        return students[student][subjectId1].marks;
    }
    

}

