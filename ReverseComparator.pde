public class ReverseComparator implements Comparator
    {
        // "reverse" the value of o1.compareTo(o2)
        public int compare(Object o1, Object o2)
        {
            Comparable c = (Comparable) o1;
            return -1 * c.compareTo(o2);
         }
    }