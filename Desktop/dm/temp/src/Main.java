import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

class LL{
    int val;
    LL next;
    public void add(int data, LL next){
        this.val = data;
        this.next = next;
        return new LL(data,net)
    }
    public boolean hasNext(LL l){
        if(l.next!=null){
            return true;
        }else{
            return false;
        }
    }
    public void addNext(LL next){
        this.next = next;
    }
    public boolean isEnd(){
        return this.next == null;
    }

}
public class Main {
    public static void main(String[] args) {
        LinkedList<Integer> li = new LinkedList<Integer>();
        li.addFirst(1);
        li.add(1,2);
        li.add(2,3);
        li.add(3,4);
        LL ll = new LL();
        ll.add(1,null);
        int ans = detectCycle(li);
        if(ans==1){
            System.out.println("cycle is present");
        }else{
            System.out.println("cycle is not present");
        }
    }
    public static int detectCycle(LinkedList<Integer> li){
        //iterate through
        Iterator<Integer> slow = li.iterator();
        Iterator<Integer> fast = li.iterator();
        while(fast!=null && fast.hasNext()){

            if(slow==fast){
                return 1;
            }
        }
        return 0;
    }
}