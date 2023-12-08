pragma solidity ^0.8.9;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MedicalRecord is Initializable {
    address public owner;
    bool private initialized;

    struct Record {
        uint id;
        string data;
        bool isDeleted;
        string userId;
        string doctorId;
        uint createdAt;
        uint updatedAt;
    }

    Record[] private medicalRecords;

    function initialize() public onlyInitializing {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only onwer can perform this action");
        _;
    }

    modifier recordExists(uint id) {
        require(
            bytes(medicalRecords[id].userId).length > 0,
            "Medical record does not exist"
        );
        require(
            medicalRecords[id].isDeleted == false,
            "Medical record has been deleted"
        );
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    event CreateRecord(address sender, uint recordId);
    event EditRecord(uint recordId);
    event DeleteRecord(uint recordId);

    function createRecord(
        string memory data,
        string memory userId,
        string memory doctorId
    ) external onlyOwner {
        uint recordId = medicalRecords.length;
        medicalRecords.push(
            Record(
                recordId,
                data,
                false,
                userId,
                doctorId,
                block.timestamp,
                block.timestamp
            )
        );
        emit CreateRecord(msg.sender, recordId);
    }

    function editRecord(
        uint id,
        string memory data
    ) external onlyOwner recordExists(id) {
        medicalRecords[id].data = data;
        medicalRecords[id].updatedAt = block.timestamp;
        emit EditRecord(id);
    }

    function deleteRecord(uint id) external onlyOwner recordExists(id) {
        medicalRecords[id].isDeleted = true;
        emit DeleteRecord(id);
    }

    function getRecordsCreatedByDoctorId(
        string memory doctorId
    ) external view returns (Record[] memory) {
        Record[] memory temp = new Record[](medicalRecords.length);
        uint counter = 0;
        for (uint i = 0; i < medicalRecords.length; i++) {
            if (
                keccak256(abi.encode(medicalRecords[i].doctorId)) ==
                keccak256(abi.encode(doctorId))
            ) {
                temp[counter] = medicalRecords[i];
                counter++;
            }
        }
        Record[] memory result = new Record[](counter);
        for (uint i = 0; i < counter; i++) result[i] = temp[i];
        return result;
    }

    function getRecordsByUserId(
        string memory userId
    ) external view returns (Record[] memory) {
        Record[] memory temp = new Record[](medicalRecords.length);
        uint counter = 0;
        for (uint i = 0; i < medicalRecords.length; i++) {
            if (
                keccak256(abi.encode(medicalRecords[i].userId)) ==
                keccak256(abi.encode(userId))
            ) {
                temp[counter] = medicalRecords[i];
                counter++;
            }
        }
        Record[] memory result = new Record[](counter);
        for (uint i = 0; i < counter; i++) result[i] = temp[i];
        return result;
    }

    function getRecordById(uint id) external view returns (Record memory) {
        return medicalRecords[id];
    }
}
