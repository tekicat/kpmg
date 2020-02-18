import unittest
from get_in import get_in

data={"a":{"b":{"c":{"d":"f"},'e':'g'}}}

class MyTest(unittest.TestCase):
    def test1(self):
        self.assertEqual(get_in(data, "a/b/c/d"),"f")
    def test2(self):
        self.assertEqual(get_in(data, "a/b/e"),"g")
    def test3(self):
        self.assertEqual(get_in(data, "a/b/f/d"),"nil")
    def test4(self):
        self.assertEqual(get_in(data, "a/b/c/d/"),"nil")

if __name__ == '__main__':
    unittest.main()