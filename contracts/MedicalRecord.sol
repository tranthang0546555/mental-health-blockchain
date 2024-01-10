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
        string numberId;
        string doctorId;
        uint createdAt;
        uint updatedAt;
    }

    struct History {
        uint id;
        uint recordId;
        string data;
        bool isDeleted;
        string userId;
        string numberId;
        string doctorId;
        uint createdAt;
        uint updatedAt;
        uint pushedAt;
    }

    struct RecordWithHistory {
        Record record;
        History[] histories;
    }

    Record[] private medicalRecords;
    History[] private histories;

    function initialize() public initializer {
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
    event UpdateRecord(uint recordId);
    event DeleteRecord(uint recordId);

    function createRecord(
        string memory data,
        string memory userId,
        string memory numberId,
        string memory doctorId
    ) external onlyOwner {
        uint recordId = medicalRecords.length;
        medicalRecords.push(
            Record(
                recordId,
                data,
                false,
                userId,
                numberId,
                doctorId,
                block.timestamp,
                block.timestamp
            )
        );
        emit CreateRecord(msg.sender, recordId);
    }

    function updateRecord(
        uint id,
        string memory data
    ) external onlyOwner recordExists(id) {
        histories.push(
            History(
                histories.length,
                medicalRecords[id].id,
                medicalRecords[id].data,
                medicalRecords[id].isDeleted,
                medicalRecords[id].userId,
                medicalRecords[id].numberId,
                medicalRecords[id].doctorId,
                medicalRecords[id].createdAt,
                medicalRecords[id].updatedAt,
                block.timestamp
            )
        );
        medicalRecords[id].data = data;
        medicalRecords[id].updatedAt = block.timestamp;
        emit UpdateRecord(id);
    }

    function deleteRecord(uint id) external onlyOwner recordExists(id) {
        histories.push(
            History(
                histories.length,
                medicalRecords[id].id,
                medicalRecords[id].data,
                medicalRecords[id].isDeleted,
                medicalRecords[id].userId,
                medicalRecords[id].numberId,
                medicalRecords[id].doctorId,
                medicalRecords[id].createdAt,
                medicalRecords[id].updatedAt,
                block.timestamp
            )
        );
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
        for (uint i = 0; i < counter; i++) result[i] = temp[counter - i - 1];
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
        for (uint i = 0; i < counter; i++) result[i] = temp[counter - i - 1];
        return result;
    }

    function getRecordsByNumberId(
        string memory numberId
    ) external view returns (Record[] memory) {
        Record[] memory temp = new Record[](medicalRecords.length);
        uint counter = 0;
        for (uint i = 0; i < medicalRecords.length; i++) {
            if (
                keccak256(abi.encode(medicalRecords[i].numberId)) ==
                keccak256(abi.encode(numberId))
            ) {
                temp[counter] = medicalRecords[i];
                counter++;
            }
        }
        Record[] memory result = new Record[](counter);
        for (uint i = 0; i < counter; i++) result[i] = temp[counter - i - 1];
        return result;
    }

    function getRecordById(uint id) external view returns (RecordWithHistory memory) {
        History[] memory temp = new History[](histories.length);
        uint counter = 0;
        for (uint i = 0; i < histories.length; i++) {
            if (
                keccak256(abi.encode(histories[i].recordId)) ==
                keccak256(abi.encode(id))
            ) {
                temp[counter] = histories[i];
                counter++;
            }
        }

        History[] memory recordsHistory = new History[](counter);
        for (uint i = 0; i < counter; i++) recordsHistory[i] = temp[i];

        RecordWithHistory memory result;
        result.record = medicalRecords[id];
        result.histories = recordsHistory;
        return result;
    }

    function getRecords() external view returns (Record[] memory) {
        Record[] memory result = new Record[](medicalRecords.length);
        for (uint i = 0; i < medicalRecords.length; i++) result[i] = medicalRecords[medicalRecords.length - i - 1];
        return result;
    }
}
