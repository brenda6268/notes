Design Twitter

# 功能列表

	1. Tweeting
	2. Timeline
		a. User
		b. Home
	3. Following

First, The naive solution, use only SQL database.
Then, optimize for 

Design Wechat

设计一个API提供每天股票交易信息

在社交网站中，如何展示两个人之间的关系（社交路径）

步骤1: 简化问题
假设问题数据量很小，那么我们用临接表表示，执行一次广度优先遍历就好了。而深度优先遍历是不好的，可能会递归深度过深。
class Person {
    vector<Person*> friends;
};

步骤2:考虑百万级的用户
当数据规模到达这么大后，不可能将所有数据存放在一台机器上。

Class Person {
    hash<int> friendIDs;
    int id;
    
    addFriend(int id) {
        firendIDs.insert(id);
    }

    hash<int> getFriends() {
        return friendIDs;
    };
};

class Machine {
    hash<int, Person*> persons;
    int id;
    
    getPersonById(int personID) {
        return persons[personID];
    }
};

class Server {
    hash<int, Machine*> machines;
    hash<int, int> personLocations;

    Machine* getMachineById(int id) {
        return machines[id];
    }

    Machine* getMachineIdByPerson(int personId) {
        return personLocations[personId];
    }

    Person* getPersonById(int personId) {
        int machineID = getMachineIdByPerson(int personId);
        Machine* machine = getMachineById(machineID);
        return machine->getPersonById(int personId);
    }
};




    
