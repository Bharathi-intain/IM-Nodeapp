// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ServicerData is AccessControl, Initializable {
    //inputs
    //0.uniqueid  1.dealid 2)month 3)year 4)input
    event uniqueId(string[] id);
    mapping(string => string[]) map; // uniqueid --> all datas
    mapping(string => bool) map1; // uid --> true / false --> to test if unique id is present
    string[] uniqueIdArray;

    function saveServicerData(string[][] memory values) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "Caller is not an invoker"
        );
        uint256 i;
        uint256 j;
        string[] memory id = new string[](values.length);
      
        for (i = 0; i < values.length; i++) {
            if(map1[values[i][0]] == false) {
                map[values[i][0]] = values[i]; // pushing all datas for unique id
                uniqueIdArray.push(values[i][0]); 
                map1[values[i][0]]= true;
            }
            else{
                id[j] = (values[i][0]); 
                j++;
            }
        }
        emit uniqueId(id);
    }

    function updateServicerData(string[][] memory values) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "Caller is not an invoker"
        );
        uint256 i;
        uint256 j;
        string[] memory id = new string[](values.length);
      
        for (i = 0; i < values.length; i++) {
            if(map1[values[i][0]] == true) {
                map[values[i][0]] = values[i]; // pushing all datas for unique id
            }
            else{
                id[j] = (values[i][0]); 
                j++;
            }
        }
        emit uniqueId(id);
    }

    function getServicerDataByDealIdMonthAndYear(
        string calldata dealId,
        string calldata month,
        string calldata year
    ) public view returns (string[][] memory) {
        string[][] memory servicerDataList = new string[][](
            uniqueIdArray.length
        );
        uint256 p = 0;
        for (uint256 h = 0; h < uniqueIdArray.length; h++) {
            string[] memory temp = map[uniqueIdArray[h]];
            if (temp.length >= 4) {
                if (
                    (keccak256(abi.encodePacked(dealId)) ==
                        keccak256(abi.encodePacked(temp[1]))) &&
                    (keccak256(abi.encodePacked(month)) ==
                        keccak256(abi.encodePacked(temp[2]))) &&
                    (keccak256(abi.encodePacked(year)) ==
                        keccak256(abi.encodePacked(temp[3])))
                ) {
                    servicerDataList[p] = map[uniqueIdArray[h]];
                    p++;
                }
            }
        }
        string[][] memory finalServicerDataList = new string[][](p);
        for (uint256 m = 0; m < p; m++) {
            finalServicerDataList[m] = servicerDataList[m];
        }
        return finalServicerDataList;
    }
    function initialize() public initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
}
