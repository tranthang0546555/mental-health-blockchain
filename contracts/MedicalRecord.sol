pragma solidity ^0.8.9;

contract MedicalRecord {
    event CreateMedicalRecord(address sender, uint recordId);
    event EditMedicalRecord(uint recordId);
    event DeleteMedicalRecord(uint recordId);
    event RestoreMedicalRecord(uint recordId);

    struct Record {
        uint id;
        address walletId;
        string data;
        bool isDeleted;
        string userId;
        string doctorId;
        uint createdAt;
        uint updatedAt;
    }

    Record[] private medicalRecords;
    mapping(uint => address) recordToOwner;

    function createMedicalRecord(
        string memory data,
        string memory userId,
        string memory doctorId
    ) external {
        uint recordId = medicalRecords.length;
        medicalRecords.push(
            Record(
                recordId,
                msg.sender,
                data,
                false,
                userId,
                doctorId,
                block.timestamp,
                block.timestamp
            )
        );
        recordToOwner[recordId] = msg.sender;
        emit CreateMedicalRecord(msg.sender, recordId);
    }

    function getRecordsbyUserId(
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

    function getRecordsbyDoctorId(
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

    function editMedicalRecord(
        uint id,
        string memory data
    ) external returns (bool) {
        if (recordToOwner[id] == msg.sender) {
            medicalRecords[id].data = data;
            medicalRecords[id].updatedAt = block.timestamp;
            emit EditMedicalRecord(id);
            return true;
        }
        return false;
    }

    function deleteMedicalRecord(uint id) external returns (bool) {
        if (recordToOwner[id] == msg.sender) {
            medicalRecords[id].isDeleted = true;
            emit DeleteMedicalRecord(id);
            return true;
        }
        return false;
    }

    function restoreMedicalRecord(uint id) external returns (bool) {
        if (recordToOwner[id] == msg.sender) {
            medicalRecords[id].isDeleted = false;
            emit RestoreMedicalRecord(id);
            return true;
        }
        return false;
    }

    function getAll() external view returns (Record[] memory) {
        Record[] memory result = new Record[](medicalRecords.length);
        for (uint i = 0; i < medicalRecords.length; i++) {
            result[i] = medicalRecords[i];
        }
        return result;
    }
}
